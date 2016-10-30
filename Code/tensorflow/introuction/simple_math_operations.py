import tensorflow as tf

# Create Constant/variable/placeholder ops. The ops are added as nodes to the default graph
# The value returned by the constructor represents the output of the ops.
input1 = tf.constant([3.0])
input2 = tf.constant([2.0])
input3 = tf.constant([5.0])
input4 = tf.placeholder(tf.float32)
input5 = tf.placeholder(tf.float32)
state = tf.Variable(0, name="counter")
one = tf.constant(1)
new_value = tf.add(state, one)
update = tf.assign(state, new_value)

# Random operations to perform
constants_mul = tf.mul(input1, input2)
intermediate = tf.add(input2, input3)
inter_mul = tf.mul(input1, intermediate)
feed_mul = tf.mul(input4, input5)

# Variables must be initialized by running an `init` Op after having
# launched the graph.  We first have to add the `init` Op to the graph.
init_op = tf.initialize_all_variables()

# Launch the graph and run the ops.
with tf.Session() as sess:

    sess.run(init_op)

    result1 = sess.run(constants_mul)
    print(result1) # 6

    print(sess.run(state))
    for _ in range(3):
        sess.run(update)
        print(sess.run(state)) # 0 1 2 3

    result2 = sess.run([inter_mul, intermediate])
    print(result2) # [array([ 21.], dtype=float32), array([ 7.], dtype=float32)]

    print(sess.run([feed_mul], feed_dict={input4:[7.], input5:[2.]})) # [array([ 14.], dtype=float32)]

# Close the Session when we're done.
sess.close()
