# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

"""Simple, end-to-end, LeNet-5-like convolutional MNIST model example.

This should achieve a test error of 0.7%. Please keep this model as simple and
linear as possible, it is meant as a tutorial for simple convolutional models.
Run with --self_test on the command line to execute a short self-test.
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import gzip
import os
import sys
import time

import numpy
import argparse
from six.moves import urllib
from six.moves import xrange  # pylint: disable=redefined-builtin
import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data


#sys.path.append(os.path.abspath("/home/phil/Repos/data/mnist_to_xy"))
#from mnist_to_python import *

SOURCE_URL = 'http://yann.lecun.com/exdb/mnist/'
WORK_DIRECTORY = 'data'
IMAGE_SIZE = 28
NUM_CHANNELS = 1
PIXEL_DEPTH = 255
NUM_LABELS = 10
VALIDATION_SIZE = 5000  # Size of the validation set.
SEED = 66478  # Set to None for random seed.
BATCH_SIZE = 64
NUM_EPOCHS = 10
EVAL_BATCH_SIZE = 64
EVAL_FREQUENCY = 100  # Number of steps between evaluations.




def data_type():
  """Return the type of the activations, weights, and placeholder variables."""
  if FLAGS.use_fp16:
    return tf.float16
  else:
    return tf.float32

def maybe_download(filename):
  """Download the data from Yann's website, unless it's already here."""
  if not tf.gfile.Exists(WORK_DIRECTORY):
    tf.gfile.MakeDirs(WORK_DIRECTORY)
  filepath = os.path.join(WORK_DIRECTORY, filename)
  if not tf.gfile.Exists(filepath):
    filepath, _ = urllib.request.urlretrieve(SOURCE_URL + filename, filepath)
    with tf.gfile.GFile(filepath) as f:
      size = f.size()
    print('Successfully downloaded', filename, size, 'bytes.')
  return filepath


def extract_data(filename, num_images):
  """Extract the images into a 4D tensor [image index, y, x, channels].

  Values are rescaled from [0, 255] down to [-0.5, 0.5].
  """
  print('Extracting', filename)
  with gzip.open(filename) as bytestream:
    bytestream.read(16)
    buf = bytestream.read(IMAGE_SIZE * IMAGE_SIZE * num_images * NUM_CHANNELS)
    data = numpy.frombuffer(buf, dtype=numpy.uint8).astype(numpy.float32)
    data = (data - (PIXEL_DEPTH / 2.0)) / PIXEL_DEPTH
    data = data.reshape(num_images, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS)
    return data


def extract_labels(filename, num_images):
  """Extract the labels into a vector of int64 label IDs."""
  print('Extracting', filename)
  with gzip.open(filename) as bytestream:
    bytestream.read(8)
    buf = bytestream.read(1 * num_images)
    labels = numpy.frombuffer(buf, dtype=numpy.uint8).astype(numpy.int64) # array of int64
  return labels


def fake_data(num_images):
  """Generate a fake dataset that matches the dimensions of MNIST."""
  data = numpy.ndarray(
      shape=(num_images, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS),
      dtype=numpy.float32)
  labels = numpy.zeros(shape=(num_images,), dtype=numpy.int64)
  for image in xrange(num_images):
    label = image % 2
    data[image, :, :, 0] = label - 0.5
    labels[image] = label
  return data, labels


def error_rate(predictions, labels):
  """Return the error rate based on dense predictions and sparse labels."""
  return 100.0 - (
      100.0 *
      numpy.sum(numpy.argmax(predictions, 1) == labels) /
      predictions.shape[0])




def main(argv=None):  # pylint: disable=unused-argument
  if tf.gfile.Exists(FLAGS.summaries_dir):
    tf.gfile.DeleteRecursively(FLAGS.summaries_dir)
  tf.gfile.MakeDirs(FLAGS.summaries_dir)

  # Import data
  mnist = input_data.read_data_sets(FLAGS.data_dir,
                                    one_hot=True,
                                    fake_data=FLAGS.fake_data)
  sess = tf.InteractiveSession()

  if FLAGS.self_test:
    print('Running self-test.')
    train_data, train_labels = fake_data(256)
    validation_data, validation_labels = fake_data(EVAL_BATCH_SIZE)
    test_data, test_labels = fake_data(EVAL_BATCH_SIZE)
    num_epochs = 1
  else:
    # Get the data.
    train_data_filename = maybe_download('train-images-idx3-ubyte.gz')
    train_labels_filename = maybe_download('train-labels-idx1-ubyte.gz')
    test_data_filename = maybe_download('t10k-images-idx3-ubyte.gz')
    test_labels_filename = maybe_download('t10k-labels-idx1-ubyte.gz')

    # Extract it into numpy arrays.
    train_data = extract_data(train_data_filename, 60000)
    train_labels = extract_labels(train_labels_filename, 60000)
    test_data = extract_data(test_data_filename, 10000)
    test_labels = extract_labels(test_labels_filename, 10000)

    # Generate a validation set (size 5000).
    validation_data = train_data[:VALIDATION_SIZE, ...]
    validation_labels = train_labels[:VALIDATION_SIZE] # from start up to validation
    train_data = train_data[VALIDATION_SIZE:, ...]
    train_labels = train_labels[VALIDATION_SIZE:] # from validation to the end
    num_epochs = NUM_EPOCHS # 10
  train_size = train_labels.shape[0]

  # This is where training samples and labels are fed to the graph.
  # These placeholder nodes will be fed a batch of training data at each
  # training step using the {feed_dict} argument to the Run() call below.
  train_data_node = tf.placeholder( data_type(), shape=(BATCH_SIZE, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS)) # float32, 64 28 28 1
  train_labels_node = tf.placeholder(tf.int64, shape=(BATCH_SIZE,))
  with tf.name_scope('input'):
    eval_data = tf.placeholder( data_type(), shape=(EVAL_BATCH_SIZE, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS), name ='image-input')
    tf.image_summary('input', eval_data, EVAL_BATCH_SIZE)


  # We can't initialize these variables to 0 - the network will get stuck.
  def weight_variable(height, width, channels_in, channels_out):
    """Create a weight variable with appropriate initialization."""
    initial = tf.truncated_normal([height, width, channels_in, channels_out],  # 5x5 filter, depth 32.
                        stddev=0.1, #small amount of noise for symetry breaking
                        seed=SEED, dtype=data_type())
    return tf.Variable(initial)
 
  def weight_variable_fc(channels_in, channels_out):
    """Create a weight variable with appropriate initialization."""
    initial = tf.truncated_normal([channels_in, channels_out],  # 5x5 filter, depth 32.
                          stddev=0.1, #small amount of noise for symetry breaking
                          seed=SEED, dtype=data_type())
    return tf.Variable(initial)

  def bias_variable_const(shape):
    """Create a bias variable with appropriate initialization."""
    initial = tf.constant(0.1, shape=[shape], dtype=data_type())
    return tf.Variable(initial)

  def bias_variable_zero(initial_size):
    """Create a bias variable with appropriate initialization."""
    initial = tf.zeros([initial_size], dtype=data_type())
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

  # Adding a name scope ensures logical grouping of the layers in the graph.
  with tf.name_scope('layers'):
    # The variables below hold all the trainable weights. They are passed an
    # initial value which will be assigned when we call:
    # {tf.initialize_all_variables().run()}
    with tf.name_scope('weights'):
      conv1_weights = weight_variable(5, 5, 1, 32)
      variable_summaries(conv1_weights, 'conv1/weights')
      conv2_weights = weight_variable(5, 5, 32, 64)
      variable_summaries(conv2_weights, 'conv2/weights')
      fc1_weights = weight_variable_fc(IMAGE_SIZE // 4 * IMAGE_SIZE // 4 * 64, 512) # fully connected, depth 512.
      variable_summaries(fc1_weights, 'fc1/weights')
      fc2_weights = weight_variable_fc(512, NUM_LABELS)
      variable_summaries(fc2_weights, 'fc2/weights')

    with tf.name_scope('biases'):
      conv1_biases = bias_variable_zero(32)
      variable_summaries(conv1_biases, 'conv1/biases')
      conv2_biases = bias_variable_const(64)
      variable_summaries(conv2_biases, 'conv2/biases')
      fc1_biases = bias_variable_const(512)
      variable_summaries(fc1_biases, 'fc1/biases')
      fc2_biases = bias_variable_const(NUM_LABELS)
      variable_summaries(fc2_biases, 'fc2/biases')
  

  # We will replicate the model structure for the training subgraph, as well
  # as the evaluation subgraphs, while sharing the trainable parameters.
  def model(data, train=False):

    """The Model definition.
    2D convolution, with 'SAME' padding (i.e. the output feature map has
    the same size as the input). Note that {strides} is a 4D array whose
    shape matches the data layout: [image index, y, x, depth]."""
    def nn_layer(data, weights, biases, name):
      """Reusable code for making a simple neural net layer.
      It sets up name scoping so that the resultant graph is easy to read,
      and adds a number of summary ops."""
      conv = tf.nn.conv2d(data, # 4d tensor [batch, in_height, in_width, in_channels]
                          weights,
                          strides=[1, 1, 1, 1],
                          padding='SAME')
      # Bias and rectified linear non-linearity.
      relu = tf.nn.relu(tf.nn.bias_add(conv, biases))
      # Max pooling. The kernel size spec {ksize} also follows the layout of
      # the data. Here we have a pooling window of 2, and a stride of 2.
      pool = tf.nn.max_pool(relu,
                            ksize=[1, 2, 2, 1],
                            strides=[1, 2, 2, 1],
                            padding='SAME')
      return pool

    layer1 = nn_layer(data, conv1_weights, conv1_biases, 'layer1')
    layer2 = nn_layer(layer1, conv2_weights, conv2_biases, 'layer2')

    # Reshape the feature map cuboid into a 2D matrix to feed it to the
    # fully connected layers.
    pool_shape = layer2.get_shape().as_list()
    reshape = tf.reshape(
        layer2,
        [pool_shape[0], pool_shape[1] * pool_shape[2] * pool_shape[3]])
    # Fully connected layer. Note that the '+' operation automatically
    # broadcasts the biases.
    hidden = tf.nn.relu(tf.matmul(reshape, fc1_weights) + fc1_biases)
    tf.histogram_summary('fc1/activations', hidden)
    # Add a 50% dropout during training only. Dropout also scales
    # activations such that no rescaling is needed at evaluation time.
    if train:
      hidden = tf.nn.dropout(hidden, 0.5, seed=SEED)
    return tf.matmul(hidden, fc2_weights) + fc2_biases

  # Training computation: logits + cross-entropy loss.
  logits = model(train_data_node, True) # logits don't add to 1, not probalilites

  with tf.name_scope('cross_entropy'):
    diff = tf.nn.sparse_softmax_cross_entropy_with_logits(
        logits, train_labels_node)
    with tf.name_scope('total'):
      loss = tf.reduce_mean(diff)
      tf.scalar_summary('cross entropy', loss) # cross entropy vs loss?

  # L2 regularization for the fully connected parameters.
  # Computes half the L2 norm of a tensor without the sqrt.
  with tf.name_scope('regularizers'):
    regularizers = (tf.nn.l2_loss(fc1_weights) + tf.nn.l2_loss(fc1_biases) +
                   tf.nn.l2_loss(fc2_weights) + tf.nn.l2_loss(fc2_biases))
    tf.scalar_summary('regularizers', regularizers)


  # Add the regularization term to the loss.
  loss += 5e-4 * regularizers

  # Optimizer: set up a variable that's incremented once per batch and
  # controls the learning rate decay.
  batch = tf.Variable(0, dtype=data_type())
  # Decay once per epoch, using an exponential schedule starting at 0.01.
  learning_rate = tf.train.exponential_decay(
      0.01,                # Base learning rate.
      batch * BATCH_SIZE,  # Current index into the dataset.
      train_size,          # Decay step.
      0.95,                # Decay rate.
      staircase=True)
  # Use simple momentum for the optimization.
  optimizer = tf.train.MomentumOptimizer(learning_rate,
                                         0.9).minimize(loss,
                                                       global_step=batch)

  # Predictions for the current training minibatch.
  with tf.name_scope('training_prediction'):
    train_prediction = tf.nn.softmax(logits)
    tf.scalar_summary('training_prediction', train_prediction)

  # Predictions for the test and validation, which we'll compute less often.
  with tf.name_scope('test_prediction'):
    eval_prediction = tf.nn.softmax(model(eval_data))
    tf.scalar_summary('test_prediction', eval_prediction)

  # Small utility function to evaluate a dataset by feeding batches of data to
  # {eval_data} and pulling the results from {eval_predictions}.
  # Saves memory and enables this to run on smaller GPUs.
  def eval_in_batches(data, sess):
    print('Test Point 2')
    """Get all predictions for a dataset by running it in small batches."""
    size = data.shape[0]
    if size < EVAL_BATCH_SIZE:
      raise ValueError("batch size for evals larger than dataset: %d" % size)
    predictions = numpy.ndarray(shape=(size, NUM_LABELS), dtype=numpy.float32)
    for begin in xrange(0, size, EVAL_BATCH_SIZE):
      end = begin + EVAL_BATCH_SIZE
      if end <= size:
        predictions[begin:end, :] = sess.run(
            eval_prediction,
            feed_dict={eval_data: data[begin:end, ...]})
      else:
        batch_predictions = sess.run(
            eval_prediction,
            feed_dict={eval_data: data[-EVAL_BATCH_SIZE:, ...]})
        predictions[begin:, :] = batch_predictions[begin - size:, :]
    return predictions

  # Merge all the summaries and write them out to /tmp/mnist_logs (by default)
  merged = tf.merge_all_summaries()
  train_writer = tf.train.SummaryWriter(FLAGS.summaries_dir + '/train',
                                        sess.graph)
  test_writer = tf.train.SummaryWriter(FLAGS.summaries_dir + '/test')

  start_time = time.time()
  print('Test Point 1')
  with tf.Session() as sess:
    # Run all the initializers to prepare the trainable parameters.
    tf.initialize_all_variables().run()
    print('Initialized!')
    # Loop through training steps.

  def feed_dict(train):
    print('Entered feed_dict')
    """Make a TensorFlow feed_dict: maps data onto Tensor placeholders."""
    if train or FLAGS.fake_data:
      xs, ys = mnist.train.next_batch(100, fake_data=FLAGS.fake_data)
      k = FLAGS.dropout
    else:
      xs, ys = mnist.test.images, mnist.test.labels
      k = 1.0
    return {x: xs, y_: ys, keep_prob: k}

    """Make a TensorFlow feed_dict: maps data onto Tensor placeholders."""
    #for step in xrange(int(num_epochs * train_size) // BATCH_SIZE):  
      # Compute the offset of the current minibatch in the data.
      # Note that we could use better randomization across epochs.
      # offset = (step * BATCH_SIZE) % (train_size - BATCH_SIZE)      # (1*64) % (55000 - 64)
      # batch_data = train_data[offset:(offset + BATCH_SIZE), ...]    # continue from offset up to offset+size, all in other dimensions
      # batch_labels = train_labels[offset:(offset + BATCH_SIZE)]
      # # This dictionary maps the batch data (as a numpy array) to the
      # # node in the graph it should be fed to.
      # feed_dict = {train_data_node: batch_data,
      #                train_labels_node: batch_labels}

  for i in range(FLAGS.max_steps):
    if i % 10 == 0:  # Record summaries and test-set accuracy
      summary, acc = sess.run([merged, eval_prediction], feed_dict=feed_dict(False))
      test_writer.add_summary(summary, i)
      print('Accuracy at step %s: %s' % (i, acc))

    else:
      if step % EVAL_FREQUENCY == 0: # Record execution stats every 100 steps
        run_options = tf.RunOptions(trace_level=tf.RunOptions.FULL_TRACE)
        run_metadata = tf.RunMetadata()
        summary, _ = sess.run([merged, train_step],
                            feed_dict=feed_dict(True),
                            options=run_options,
                            run_metadata=run_metadata)
        train_writer.add_run_metadata(run_metadata, 'step%03d' % i)
        train_writer.add_summary(summary, i)
        print('Adding run metadata for', i)
        print('My prediction is: %d' % predictions[1,0])
    
        elapsed_time = time.time() - start_time
        start_time = time.time()
        print('Step %d (epoch %.2f), %.1f ms' %
              (step, float(step) * BATCH_SIZE / train_size,
              1000 * elapsed_time / EVAL_FREQUENCY))
        print('Minibatch loss: %.3f, learning rate: %.6f' % (l, lr))
        print('Minibatch error: %.1f%%' % error_rate(predictions, batch_labels))
        print('Validation error: %.1f%%' % error_rate(
              eval_in_batches(validation_data, sess), validation_labels))
        print('My prediction is: %d' % predictions[1,0])
        sys.stdout.flush()
      else:
        # Run the graph and fetch some of the nodes.
        _, l, lr, predictions = sess.run(
        [optimizer, loss, learning_rate, train_prediction],
        feed_dict=feed_dict)

    # Finally print the result!
    test_error = error_rate(eval_in_batches(test_data, sess), test_labels)
    print('Test error: %.1f%%' % test_error)
    
    if FLAGS.self_test:
      print('test_error', test_error)
      assert test_error == 0.0, 'expected 0.0 test_error, got %.2f' % (
          test_error,)


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
  parser.add_argument('self_test', nargs='?', const=True, type=bool,
                      default=False,
                      help='True if running a self test.')  
  parser.add_argument('use_fp16', nargs='?', const=True, type=bool,
                      default=False,
                      help='Use half floats instead of full floats if True.')  
  FLAGS = parser.parse_args()
  tf.app.run()


# tf.app.flags.DEFINE_boolean("self_test", False, "True if running a self test.")
# tf.app.flags.DEFINE_boolean('use_fp16', False,
#                             "Use half floats instead of full floats if True.")
# FLAGS = tf.app.flags.FLAGS