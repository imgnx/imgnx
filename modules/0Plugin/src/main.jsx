import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import waitForElement from "./components/waitForElement";
const container = "#plugin-container";
const rootId = "plugin-root";

async function reload() {
  console.log("CSS FORMS Reloaded");

  waitForElement(container)
    .then(async (element) => {
      if (
        !document.querySelector("#" + rootId) &&
        window.location.href.includes("kze9E7yvO9NA0vKRC09E")
      ) {
        const root = document.createElement("div");
        root.id = rootId;
        element.prepend(root);
        ReactDOM.createRoot(root).render(
          <React.StrictMode>
            <div>Your plugin</div>
          </React.StrictMode>
        );
      }
    })
    .finally(async (element) => {
      const callback = async (mutationList, observer) => {
        if (mutationList.some((record) => record.addedNodes.length > 0)) {
        }
      };
      const observer = new MutationObserver(callback);
      const target = document.getElementById("app");
      observer.observe(target, { childList: true, subtree: true });
    });
}

window.addEventListener("locationChangeEvent", async (event) => {
  console.log("Location change");
  reload();
});

window.addEventListener("routeChangeEvent", async (event) => {
  console.log("CSS FORMS Route change");
  reload();
});

console.log("CSS FORMS 1");
