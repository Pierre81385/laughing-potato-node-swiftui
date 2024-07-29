const express = require('express');
const bodyParser = require('body-parser');
const cors = require("cors");
const dotenv = require("dotenv");
const http = require("http"); // Require the http module
const socketIo = require("socket.io"); // Require the socket.io module
const mongoose = require("mongoose");

const clickup = require("./routes/ClickUp")

dotenv.config();

const app = express();
const port_api = process.env.PORT_API || 3000;
const port_socket = process.env.PORT_SOCKET || 4200;

app.use(bodyParser.json());
app.use(cors());
app.use(express.json());
app.get('/', (req, res) => {
    res.send('Hello from Node.js server!');
  });
  
app.post('/data', (req, res) => {
    console.log(req.body);
res.send('Data received');
});
  
app.listen(port_api, () => {
    console.log(`Server running at http://localhost:${port_api}`);
    console.log(`Socket.io listening on port: ${port_socket}`);
});

// Socket.IO setup
const server = http.createServer(app); 
const io = socketIo(server, {
  cors: {
    origin: [`http://localhost:${port_socket}`],
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
}); 

// Pass the io instance to the routes
app.use((req, res, next) => {
    req.io = io;
    next();
  });

io.listen(port_socket)

io.on("connection", (socket) => {
    console.log(`A user connected`);

    socket.on("press", (data) => {
        console.log(JSON.stringify(data))
    })

    socket.on("Webhook Payload Received", (data) => {
        console.log(JSON.stringify(data));
    })
  
    socket.on("disconnect", (data) => {
      console.log("A user disconnected");
    });
  });

app.use(
    cors({
    origin: [`http://localhost:${port_socket}`],
    methods: ["GET", "POST", "PUT", "DELETE"],
})
);

//mongodb setup 
const uri = process.env.ATLAS_URI;
mongoose.connect(uri);
const connection = mongoose.connection;
connection.once("open", () => {
  console.log("MongoDB database connection established successfully");
});

