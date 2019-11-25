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

import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

const liveSocket = new LiveSocket("/live", Socket);

liveSocket.getSocket().onOpen(() => {
  document.documentElement.classList.remove("dashbling-disconnected");
});

liveSocket.getSocket().onClose(() => {
  document.documentElement.classList.add("dashbling-disconnected");
});

liveSocket.getSocket().onMessage(() => {
  const now = new Intl.DateTimeFormat(navigator.languages, {
    year: "numeric",
    month: "numeric",
    day: "numeric",
    hour: "numeric",
    minute: "numeric"
  }).format(new Date());

  document.querySelector(
    ".dashbling-last-updated"
  ).innerText = `Last updated: ${now}`;
});

liveSocket.connect();

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
