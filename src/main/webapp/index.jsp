
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>Super Mario Adventure</title>

<style>
* { box-sizing: border-box; }

body {
    margin: 0;
    text-align: center;
    font-family: Arial;
    background: #70d6ff;
}

h1 {
    color: #e63926;
    text-shadow: 2px 2px white;
}

#score {
    font-size: 25px;
    font-weight: bold;
    color: #222;
    margin: 15px;
}

canvas {
    width: 95%;
    max-width: 900px;
    background: #54c8ff;
    border: 5px solid white;
    border-radius: 10px;
}

button {
    padding: 12px 25px;
    background: #e63926;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 18px;
    cursor: pointer;
}

button:hover {
    background: #a51c10;
}

.controls {
    margin: 15px;
    font-weight: bold;
}
</style>
</head>

<body>

<h1>🍄 SUPER MARIO ADVENTURE 🍄</h1>

<div id="score">Score: 0</div>

<canvas id="game" width="900" height="450"></canvas>

<br><br>

<button onclick="restart()">START GAME</button>

<div class="controls">
    ⬅ LEFT | RIGHT ➡ | SPACE = JUMP
</div>

<script>

const canvas = document.getElementById("game");
const ctx = canvas.getContext("2d");

let mario, coins, enemies, score, running;
let keys = {};

function restart() {

    mario = {
        x: 50,
        y: 355,
        w: 35,
        h: 45,
        vy: 0,
        grounded: false
    };

    coins = [
        {x: 200, y: 280, got: false},
        {x: 280, y: 240, got: false},
        {x: 420, y: 200, got: false},
        {x: 550, y: 280, got: false},
        {x: 700, y: 240, got: false}
    ];

    enemies = [
        {x: 450, y: 370, w: 30, h: 30, vx: 2}
    ];

    score = 0;
    running = true;

    document.getElementById("score").innerText =
        "Score: 0";

    update();
}

document.addEventListener("keydown", function(e) {

    keys[e.code] = true;

    if (["ArrowLeft", "ArrowRight", "Space"].includes(e.code))
        e.preventDefault();

    if (e.code === "Space" && mario.grounded && running) {
        mario.vy = -13;
        mario.grounded = false;
    }
});

document.addEventListener("keyup", function(e) {
    keys[e.code] = false;
});

function drawBackground() {

    ctx.fillStyle = "#54c8ff";
    ctx.fillRect(0, 0, 900, 450);

    // Clouds
    ctx.fillStyle = "white";

    [100, 350, 650].forEach(x => {
        ctx.beginPath();
        ctx.arc(x, 80, 25, 0, Math.PI * 2);
        ctx.arc(x + 25, 80, 20, 0, Math.PI * 2);
        ctx.fill();
    });

    // Hills
    ctx.fillStyle = "#37bd48";

    ctx.beginPath();
    ctx.arc(150, 400, 100, Math.PI, 0);
    ctx.arc(550, 400, 130, Math.PI, 0);
    ctx.fill();

    // Ground
    ctx.fillStyle = "#8b4513";
    ctx.fillRect(0, 400, 900, 50);

    ctx.fillStyle = "#32cd32";
    ctx.fillRect(0, 400, 900, 10);
}

function drawMario() {

    // Hat
    ctx.fillStyle = "red";
    ctx.fillRect(mario.x + 3, mario.y, 30, 12);

    // Face
    ctx.fillStyle = "#ffcc99";
    ctx.fillRect(mario.x + 5, mario.y + 12, 27, 13);

    // Body
    ctx.fillStyle = "blue";
    ctx.fillRect(mario.x + 4, mario.y + 25, 28, 14);

    // Shoes
    ctx.fillStyle = "brown";
    ctx.fillRect(mario.x, mario.y + 39, 15, 6);
    ctx.fillRect(mario.x + 21, mario.y + 39, 15, 6);

    // Eye
    ctx.fillStyle = "black";
    ctx.fillRect(mario.x + 24, mario.y + 16, 4, 4);
}

function drawPlatforms() {

    let platforms = [
        {x: 180, y: 320, w: 120},
        {x: 380, y: 270, w: 120},
        {x: 600, y: 320, w: 120}
    ];

    platforms.forEach(p => {

        ctx.fillStyle = "#a0522d";
        ctx.fillRect(p.x, p.y, p.w, 18);

        ctx.fillStyle = "#32cd32";
        ctx.fillRect(p.x, p.y, p.w, 6);

    });

}

function drawCoins() {

    coins.forEach(c => {

        if (!c.got) {

            ctx.fillStyle = "gold";
            ctx.beginPath();
            ctx.arc(c.x, c.y, 12, 0, Math.PI * 2);
            ctx.fill();

            ctx.strokeStyle = "orange";
            ctx.lineWidth = 3;
            ctx.stroke();

        }

    });

}

function update() {

    if (!running) return;

    drawBackground();

    // Movement
    if (keys["ArrowRight"]) mario.x += 5;
    if (keys["ArrowLeft"]) mario.x -= 5;

    mario.x = Math.max(0, Math.min(865, mario.x));

    let oldY = mario.y;

    mario.vy += 0.6;
    mario.y += mario.vy;

    mario.grounded = false;

    // Ground collision
    if (mario.y + mario.h >= 400) {

        mario.y = 400 - mario.h;
        mario.vy = 0;
        mario.grounded = true;

    }

    // Platform collision
    let platforms = [
        {x: 180, y: 320, w: 120},
        {x: 380, y: 270, w: 120},
        {x: 600, y: 320, w: 120}
    ];

    platforms.forEach(p => {

        if (
            mario.x + mario.w > p.x &&
            mario.x < p.x + p.w &&
            oldY + mario.h <= p.y &&
            mario.y + mario.h >= p.y &&
            mario.vy >= 0
        ) {

            mario.y = p.y - mario.h;
            mario.vy = 0;
            mario.grounded = true;

        }

    });

    // Coin collection
    coins.forEach(c => {

        if (!c.got &&
            mario.x < c.x + 12 &&
            mario.x + mario.w > c.x - 12 &&
            mario.y < c.y + 12 &&
            mario.y + mario.h > c.y - 12) {

            c.got = true;
            score += 10;

            document.getElementById("score").innerText =
                "Score: " + score;

        }

    });

    // Enemy movement
    enemies.forEach(e => {

        e.x += e.vx;

        if (e.x < 350 || e.x > 650) {
            e.vx *= -1;
        }

        ctx.fillStyle = "purple";
        ctx.fillRect(e.x, e.y, e.w, e.h);

        // Enemy collision
        if (
            mario.x < e.x + e.w &&
            mario.x + mario.w > e.x &&
            mario.y < e.y + e.h &&
            mario.y + mario.h > e.y
        ) {

            if (mario.vy > 0 && oldY + mario.h <= e.y + 10) {

                e.x = -100;
                mario.vy = -9;
                score += 20;

            } else {

                endGame("GAME OVER!");
                return;

            }

        }

    });

    drawPlatforms();
    drawCoins();
    drawMario();

    if (coins.every(c => c.got)) {
        endGame("YOU WIN!");
        return;
    }

    if (mario.y > 450) {
        endGame("GAME OVER!");
        return;
    }

    requestAnimationFrame(update);

}

function endGame(message) {

    running = false;

    ctx.fillStyle = "white";
    ctx.font = "bold 45px Arial";
    ctx.fillText(message, 320, 210);

    ctx.font = "20px Arial";
    ctx.fillText("Click START GAME to play again", 280, 250);

}

restart();

</script>

</body>
</html>

