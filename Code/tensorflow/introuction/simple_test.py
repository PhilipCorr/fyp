import tensorflow as tf

input = tf.Variable(tf.random_normal([1,2,2,1])) # 1 image, size 2x2, 1 channel
filter = tf.Variable(tf.random_normal([1,1,1,1])) # 1 filter, size 1x1, 1 channel

op = tf.nn.conv2d(input, filter, strides=[1, 1, 1, 1], padding='SAME')
init = tf.initialize_all_variables()
with tf.Session() as sess:
    sess.run(init)

    print("input")
    print(input.eval())
    print("filter")
    print(filter.eval())
    print("result")
    result = sess.run(op)
    print(result)
