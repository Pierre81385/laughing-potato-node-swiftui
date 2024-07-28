const express = require('express');
const bodyParser = require('body-parser');
const cors = require("cors");
const dotenv = require("dotenv");
const http = require("http"); // Require the http module
const socketIo = require("socket.io"); // Require the socket.io module

dotenv.config();

const app = express();
const port_server = process.env.PORT || 3000;
const port_socket = process.env.PORT_SOCKET || 4200;

app.use(bodyParser.json());
app.use(cors());
app.use(express.json());

const server = http.createServer(app); // Create an HTTP server
const io = socketIo(server, {
  cors: {
    origin: [`http://localhost:${port_socket}`],
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
}); // Initialize Socket.IO with the server

io.listen(port_socket)

// Socket.IO setup
io.on("connection", (socket) => {
    console.log(`A user connected`);
  
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
  

app.get('/', (req, res) => {
  res.send('Hello from Node.js server!');
});

app.post('/data', (req, res) => {
  console.log(req.body);
  res.send('Data received');
});

app.listen(port_server, () => {
  console.log(`Server running at http://localhost:${port_server}`);
});