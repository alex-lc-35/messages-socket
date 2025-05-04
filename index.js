const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);

const { Server } = require("socket.io");
const io = new Server(server, {
    cors: {
        origin: "*"
    }
});

app.use(express.json());

app.get("/", (req, res) => {
    res.send("✅ Hello depuis sandbox-socket via Traefik !");
    console.log("Hello depuis sandbox-socket via Traefik ");
});


app.post("/api/send", (req, res) => {
    const msg = req.body;
    console.log(`${new Date().toISOString()} 📨 Reçu de projet-4 :`, msg);
    io.emit("chat message", msg);
    res.json({ status: "ok", received: msg });
});

io.on("connection", (socket) => {
    console.log(`${new Date().toISOString()}🟢 Nouveau client connecté`);

    socket.on("chat message", (msg) => {
        console.log(`${new Date().toISOString()}💬 Message reçu :`, msg);
        io.emit("chat message", msg);
    });

    socket.on("disconnect", () => {
        console.log(`${new Date().toISOString()}🔌 Client déconnecté`);
    });
});

server.listen(3000, () => {
    console.log(`${new Date().toISOString()}🚀 Serveur WebSocket + HTTP sur le port 3000`);
});
