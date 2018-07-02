# sliding-window-evolving-network-with-R-and-Gephi-Server

- Implementation with R language of a sliding window edge list from a MySql database.

- This code example uses RODBC R package and the Gephi's Graph Streaming API available in:

    - https://github.com/gephi/gephi/wiki/GraphStreaming#Graph_Streaming_API

More info:

Social Networks Visualization and Analysis is the goal of our work. Social Networks or graphs represent connections between actors in a network. In our study we used a telecommunications network with more than ten million connections or calls per day, representing more than six million of unique users per day. We had one hundred and thirty five days of data, the big question was, How do we visualize all this data? By using Streaming!

We built a system to do visualization of huge social networks whose connections were also defined by its timing information, with other words the data had timestamps. What you are seeing is the sliding window representation of this social network. You can see single connections appearing on the screen as time goes by. This is our way of avoiding too much connections on the screen. This way we avoid making it impossible to see so many connections or crashing the computer.

- Ego Networks

Sometimes we wanted to check the evolving network of a particular node. We call those networks Ego-Networks. They are nothing more than networks centered on a specific actor. In this implementation we can see the neighbors of this ego actor and also its second order connections, in other words, its neighbors' connections.

We also developed a web based implementation of the Ego-Network streaming algorithm. This way, work teams in remote locations around the world can also see the evolving streaming in their browsers anywhere in the world.

Watch a demo video of these systems in the following link:

https://youtu.be/050uZSYkk6k
