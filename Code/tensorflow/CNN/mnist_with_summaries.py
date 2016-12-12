# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""A simple MNIST classifier which displays summaries in TensorBoard.
 This is an unimpressive MNIST model, but it is a good example of using
tf.name_scope to make a graph legible in the TensorBoard graph explorer, and of
naming summary tags so that they are grouped meaningfully in TensorBoard.
It demonstrates the functionality of every TensorBoard dashboard.
"""
from __future__ import absolute_import
from __future__ import division 
from __future__ import print_function 
 
import gzip 
import numpy 
import argparse 
 
import tensorflow as tf 
 
from tensorflow.python.framework import dtypes 
from tensorflow.python.platform import gfile 
from tensorflow.contrib.learn.python.learn.datasets import base 
from tensorflow.python.framework import dtypes 
from tensorflow.examples.tutorials.mnist import input_data 
from tensorflow.contrib.learn.python.learn.datasets import mnist 
 
 
FLAGS = None 
 
def extract_gestures(filename): 
  """Extract the images into a 4D uint8 numpy array [index, y, x, depth].""" 
  print('Extracting', filename) 
  with gfile.Open(filename, 'rb') as f, gzip.GzipFile(fileobj=f) as bytestream: 
    buf = bytestream.read() 
    data = numpy.frombuffer(buf, dtype=numpy.uint8) 
    print('size of gesture data: %s' % len(data)) 
    data = data.reshape(1, 28, 28, 1) # 1 image, 28x28 pixels and 1 channel 
    return data 
 
def extract_labels(filename, one_hot=False, num_classes=10): 
  """Extract the labels into a 1D uint8 numpy array [index].""" 
  print('Extracting', filename) 
  with gfile.Open(filename, 'rb') as f, gzip.GzipFile(fileobj=f) as bytestream: 
    num_items = mnist._read32(bytestream) 
    buf = bytestream.read(num_items) 
    labels = numpy.frombuffer(buf, dtype=numpy.uint8) 
    if one_hot: 
      return dense_to_one_hot(labels, num_classes) 
    return labels 
 
def import_gestures(): 
  extracted_gesture = mnist.extract_images(FLAGS.data_test_gesture_file) 
  gesture_label =  mnist.extract_labels(FLAGS.data_test_label_file, one_hot=True) 
  gesture_dataset = mnist.DataSet(extracted_gesture, gesture_label, dtype=dtypes.float32, reshape=True) 
  return gesture_dataset 
   
def train(): 
  # Import data 
  mnist = input_data.read_data_sets(FLAGS.data_dir, 
                                    one_hot=True, 
                                    fake_data=FLAGS.fake_data) 
  gesture_set = import_gestures() 
 
  print('gesture image shape: %s gesture label shape: %s' % (gesture_set.images.shape, gesture_set.labels.shape)) 
  print('mnist train image shape: %s mnist train label shape: %s' % (mnist.train.images.shape, mnist.train.labels.shape)) 
 
  #gesture_images = gesture_set.next_batch(100, fake_data=False) 
  xs, ys = mnist.train.next_batch(100, fake_data=FLAGS.fake_data) 
 
  sess = tf.InteractiveSession() 
 
  # Create a multilayer model. 
 
  # Input placeholders 
  # Takes in Binary file input and reads in 784 bits 
  with tf.name_scope('input'): 
    x = tf.placeholder(tf.float32, [None, 784], name='x-input') 
    y_ = tf.placeholder(tf.float32, [None, 10], name='y-input') 
  with tf.name_scope('gesture-input'): 
    g = tf.placeholder(tf.float32, [None, 784], name='g-input') 
 
  with tf.name_scope('input_reshape'): 
    image_shaped_input = tf.reshape(x, [-1, 28, 28, 1]) 
    tf.image_summary('input', image_shaped_input, 10) 
  with tf.name_scope('gesture_input_reshape'): 
    gesture_shaped_input = tf.reshape(g, [-1, 28, 28, 1]) 
    tf.image_summary('gesture-input', gesture_shaped_input, 10) 

  # We can't initialize these variables to 0 - the network will get stuck.
  def weight_variable(shape):
    """Create a weight variable with appropriate initialization."""
    initial = tf.truncated_normal(shape, stddev=0.1)
    return tf.Variable(initial)

  def bias_variable(shape):
    """Create a bias variable with appropriate initialization."""
    initial = tf.constant(0.1, shape=shape)
    return tf.Variable(initial)

  def variable_summaries(var, name):
    """Attach a lot of summaries to a Tensor."""
    with tf.name_scope('summaries'):
      mean = tf.reduce_mean(var)
      tf.scalar_summary('mean/' + name, mean)
      with tf.name_scope('stddev'):
        stddev = tf.sqrt(tf.reduce_mean(tf.square(var - mean)))
      tf.scalar_summary('stddev/' + name, stddev)
      tf.scalar_summary('max/' + name, tf.reduce_max(var))
      tf.scalar_summary('min/' + name, tf.reduce_min(var))
      tf.histogram_summary(name, var)

  def nn_layer(input_tensor, input_dim, output_dim, layer_name, act=tf.nn.relu):
    """Reusable code for making a simple neural net layer.
    It does a matrix multiply, bias add, and then uses relu to nonlinearize.
    It also sets up name scoping so that the resultant graph is easy to read,
    and adds a number of summary ops.
    """
    # Adding a name scope ensures logical grouping of the layers in the graph.
    with tf.name_scope(layer_name):
      # This Variable will hold the state of the weights for the layer
      with tf.name_scope('weights'):
        weights = weight_variable([input_dim, output_dim])
        variable_summaries(weights, layer_name + '/weights')
      with tf.name_scope('biases'):
        biases = bias_variable([output_dim])
        variable_summaries(biases, layer_name + '/biases')
      with tf.name_scope('Wx_plus_b'):
        preactivate = tf.matmul(input_tensor, weights) + biases
        tf.histogram_summary(layer_name + '/pre_activations', preactivate)
      activations = act(preactivate, name='activation')
      tf.histogram_summary(layer_name + '/activations', activations)
      return activations

  hidden1 = nn_layer(x, 784, 500, 'layer1')

  with tf.name_scope('dropout'):
    keep_prob = tf.placeholder(tf.float32)
    tf.scalar_summary('dropout_keep_probability', keep_prob)
    dropped = tf.nn.dropout(hidden1, keep_prob)

  # Do not apply softmax activation yet, see below.
  y = nn_layer(dropped, 500, 10, 'layer2', act=tf.identity)

  with tf.name_scope('cross_entropy'):
    # The raw formulation of cross-entropy,
    #
    # tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(tf.softmax(y)),
    #                               reduction_indices=[1]))
    #
    # can be numerically unstable.
    #
    # So here we use tf.nn.softmax_cross_entropy_with_logits on the
    # raw outputs of the nn_layer above, and then average across
    # the batch.
    diff = tf.nn.softmax_cross_entropy_with_logits(y, y_)
    with tf.name_scope('total'):
      cross_entropy = tf.reduce_mean(diff)
    tf.scalar_summary('cross entropy', cross_entropy)

  with tf.name_scope('train'):
    train_step = tf.train.AdamOptimizer(FLAGS.learning_rate).minimize(
        cross_entropy)

  with tf.name_scope('accuracy'):
    with tf.name_scope('correct_prediction'):
      correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_, 1))
    with tf.name_scope('accuracy'):
      accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
    tf.scalar_summary('accuracy', accuracy)

  # Merge all the summaries and write them out to /tmp/mnist_logs (by default)
  merged = tf.merge_all_summaries()
  train_writer = tf.train.SummaryWriter(FLAGS.summaries_dir + '/train',
                                        sess.graph)
  test_writer = tf.train.SummaryWriter(FLAGS.summaries_dir + '/test')
  tf.initialize_all_variables().run()

  # Train the model, and also write summaries.
  # Every 10th step, measure test-set accuracy, and write test summaries
  # All other steps, run train_step on training data, & add training summaries

  def feed_dict(train):
    """Make a TensorFlow feed_dict: maps data onto Tensor placeholders."""
    if train or FLAGS.fake_data:
      xs, ys = mnist.train.next_batch(100, fake_data=FLAGS.fake_data)
      gs = gesture_set.images
      k = FLAGS.dropout
    else:
      xs, ys = mnist.test.images, mnist.test.labels
      gs = gesture_set.images
      k = 1.0
    return {x: xs, y_: ys, g: gs, keep_prob: k}

  for i in range(FLAGS.max_steps):
    if i % 10 == 0:  # Record summaries and test-set accuracy
      summary, acc = sess.run([merged, accuracy], feed_dict=feed_dict(False))
      test_writer.add_summary(summary, i)
      print('Accuracy at step %s: %s' % (i, acc))
    else:  # Record train set summaries, and train
      if i % 100 == 99:  # Record execution stats
        run_options = tf.RunOptions(trace_level=tf.RunOptions.FULL_TRACE)
        run_metadata = tf.RunMetadata()
        summary, _ = sess.run([merged, train_step],
                              feed_dict=feed_dict(True),
                              options=run_options,
                              run_metadata=run_metadata)
        train_writer.add_run_metadata(run_metadata, 'step%03d' % i)
        train_writer.add_summary(summary, i)
        print('Adding run metadata for', i)
      else:  # Record a summary
        summary, _ = sess.run([merged, train_step], feed_dict=feed_dict(True))
        train_writer.add_summary(summary, i)
  train_writer.close()
  test_writer.close()


def main(_):
  if tf.gfile.Exists(FLAGS.summaries_dir):
    tf.gfile.DeleteRecursively(FLAGS.summaries_dir)
  tf.gfile.MakeDirs(FLAGS.summaries_dir)
  train()


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--fake_data', nargs='?', const=True, type=bool,
                      default=False,
                      help='If true, uses fake data for unit testing.')
  parser.add_argument('--max_steps', type=int, default=1000,
                      help='Number of steps to run trainer.')
  parser.add_argument('--learning_rate', type=float, default=0.001,
                      help='Initial learning rate')
  parser.add_argument('--dropout', type=float, default=0.9,
                      help='Keep probability for training dropout.')
  parser.add_argument('--data_dir', type=str, default='/tmp/data',
                      help='Directory for storing data')
  parser.add_argument('--summaries_dir', type=str, default='/tmp/mnist_logs',
                      help='Summaries directory')
  parser.add_argument('--fake_test_data', nargs='?', const=True, type=bool, 
                      default=True, 
                      help='If true, adds gestures')
  parser.add_argument('--data_test_gesture_file', type=str, default='/tmp/data_test/data.idx3-ubyte.gz', 
                      help='Directory for storing test data') 
  parser.add_argument('--data_test_label_file', type=str, default='/tmp/data_test/label.idx1-ubyte.gz', 
                      help='Directory for storing test data')
  FLAGS = parser.parse_args()
  tf.app.run()