const express = require('express');

const app = express();
const bodyParser = require('body-parser');
const upload = require('multer')();

const server = require('http').Server(app);

const hostname = '127.0.0.1';
const port = 9494;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.static(__dirname));
app.get('/', (req, res) => {
	res.sendFile(__dirname + '/client/index.html');
});

let reply = null;
let oracle = null;

app.post('/ask', upload.array(), (req, res) => {
	console.log(req.body);
	const question = req.body;

	if (oracle === null) {
		res.json({ error: true, data: 'NoOracle' });
	} else {
		oracle.on('answer', answer => {
			res.json({ error: false, data: answer });
		});

		oracle.emit('question', question);
	}
});

const io = require('socket.io')(server);

io.on('connection', socket => {
	console.log('Client connected');

	oracle = socket;
	socket.on('disconnect', () => {
		oracle = null;
	});
});

server.listen(port, () => console.log(`Server running on port ${port}`));
