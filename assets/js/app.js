import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

import { Calendar } from "@fullcalendar/core";
import jaLocale from "@fullcalendar/core/locales/ja";

import dayGridPlugin from "@fullcalendar/daygrid";
import listPlugin from "@fullcalendar/list";
import "../css/custom.css";

let calendarEl = document.getElementById("calendar");
let calendar = new Calendar(calendarEl, {
  plugins: [dayGridPlugin, listPlugin],
  initialView: "dayGridMonth",
  locale: jaLocale,
  headerToolbar: {
    left: "prev,next",
    center: "title",
    right: "dayGridMonth,listMonth",
  },
  dayCellContent: function (e) {
    e.dayNumberText = e.dayNumberText.replace("日", "");
  },
  eventDisplay: "block",
  events: {
    url: "/events",
    extraParams: function () {
      let selectEl = document.getElementById("source");
      return {
        source: selectEl.value,
      };
    },
  },
  contentHeight: "auto",
  eventDidMount: function (info) {
    let dotEl = info.el.getElementsByClassName("fc-list-event-dot")[0];

    if (dotEl) {
      dotEl.style.display = "none";
    }
  },
  eventClick: function(event) {
    if (event.event.url) {
      event.jsEvent.preventDefault();
      window.open(event.event.url, "_blank");
    }
  },
});
let selectEl = document.getElementById("source");
selectEl.addEventListener("change", (e) => {
  calendar.getEventSources()[0].refetch();
});

calendar.render();
