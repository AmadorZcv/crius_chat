// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
//import socket from "./socket"
import { Socket, Presence } from "phoenix";
import LiveSocket from "phoenix_live_view";

let liveSocket = new LiveSocket("/live", Socket);
liveSocket.connect();

let socket = new Socket("/socket", {
    params: { user_id: window.location.search.split("=")[1] }
})



let channel = socket.channel("lobby:lobby", {})
let userChannel = socket.channel("user:" + window.location.search.split("=")[1], {})

channel.on("open_convo", msg => console.log("Got message", msg))
userChannel.on("open_convo", (payload) => console.log("Payload", payload))
userChannel.onMessage("open_convo", (payload) => console.log("Payload", payload))


let presence = new Presence(channel)
userChannel.join()
console.log("Aqui")
userChannel.push("talk_to", { body: "asd" }, 10000)
    .receive("ok", (msg) => console.log("created message", msg))
    .receive("error", (reasons) => console.log("create failed", reasons))
    .receive("timeout", () => console.log("Networking issue..."))
function renderOnlineUsers(presence) {
    let response = ""

    presence.list((id, { metas: [first, ...rest] }) => {
        let count = rest.length + 1
        response += `<br>${id} (count: ${count})</br>`
    })

    document.querySelector("main[role=main]").innerHTML = response
}

socket.connect()

presence.onSync(() => renderOnlineUsers(presence))

channel.join()