import { fetchNui } from "./fetchNui.js";

function Realtime() {
  let interval = setInterval(() => {
    const date = new Date();
    let minutes = date.getMinutes();
    let seconds = date.getSeconds();
    if (minutes < 10) {
      minutes = "0" + minutes;
    }
    if (seconds < 10) {
      seconds = "0" + seconds;
    }

    const time = date.getHours() + ":" + minutes + ":" + seconds;
    $("#time").html(`<a class="navbar-brand fs-1">${time}</a>`);
  }, 1000);
}

let date = new Date().toLocaleDateString();
$("#date").html(`<a class="navbar-brand fs-4">${date}<br /></a>`);

function weekday() {
  let date = new Date();
  let dayOfWeekNumber = date.getDay();
  let nameOfDay;

  switch (dayOfWeekNumber) {
    case 0:
      nameOfDay = "Sunday";
      break;
    case 1:
      nameOfDay = "Monday";
      break;
    case 2:
      nameOfDay = "Tuesday";
      break;
    case 3:
      nameOfDay = "Wednesday";
      break;
    case 4:
      nameOfDay = "Thursday";
      break;
    case 5:
      nameOfDay = "Friday";
      break;
    case 6:
      nameOfDay = "Saturday";
      break;
  }

  $("#weekday").html(`<a class="navbar-brand fs-4">${nameOfDay}</a>`);
}

window.addEventListener("message", (e) => {
  let event = e.data;
  if (event.action == "openui") {
    Realtime();
    weekday();
    var Theme = event.theme;
    document.documentElement.setAttribute("data-theme", Theme);
    $(".main-container").css("display", "flex");
    $(".main-content").removeClass("animate__animated animate__zoomIn");
  }
  if (event.action == "Setprofile") {
    var user_profile = event.pr_img;
    var user_img = `<img
    src= "${user_profile}"
    alt="profile picture"
    id="user_img"
    width="100"
    height="100"
    class="prf-img rounded-circle me-2"
  />`;
    $("#user_img").html(user_img);
  }
  if (event.action == "Setmugshot") {
    var user_mugshot = event.mugshot_img;
    var user_img = `<img
    src= "${user_mugshot}"
    class="my-3"
    alt=""
    id="player-mugshot"
    width="200"
    height="200"
    style="border-radius: 20px"
  />`;
    $("#player-mugshot").html(user_img);
  }
  if (event.action == "Setcount") {
    $("#player-count").html(`<h5 id="player-count">${event.player_count}</h5>`);
    $("#player-ping").html(`<h5 id="player-ping">${event.player_ping}ms</h5>`);
  }

  if (event.action == "Setooc") {
    var number = Math.floor(Math.random() * 1000 + 1);
    var oocMsg = `
    <div id = "msg-head" class="msg-head-${number} p-2">${event.oocName}: <span class="msg text-wrap">${event.oocText}</span></div>`;
    $("#ooc_msg").append(oocMsg);
  }
  if (event.action == "SetPlayerdetails") {
    $("#firstName").html(`<h3>: ${event.PlayerData.firstName}</h3>`);
    $("#lastName").html(`<h3>: ${event.PlayerData.lastName}</h3>`);
    $("#sex").html(`<h3>: ${event.PlayerData.sex}</h3>`);
    $("#job").html(`<h3>: ${event.PlayerData.job}</h3>`);
    $("#pr_name").html(`<h2>${event.PlayerData.firstName}</h2>`);
    $("#pr_job").html(`<span class="job">${event.PlayerData.jobName}</span>`);
    $("#player-money").html(
      `<h5 id="player-money">$${event.PlayerData.cash}</h5>`
    );
    $("#player-bank").html(
      `<h5 id="player-bank">$${event.PlayerData.bank}</h5>`
    );
  }

  if (event.action == "SetPatchnotes") {
    var PatchDate = event.PatchnoteDate;
    var PatchNotes = event.Patchnotes;
    $("#patchdate").html(`<h6
    class="card-subtitle mb-2 text-start"
    style="color: rgb(255, 255, 255)"
    id="patchdate"
     >${PatchDate}</h6>`);
    $("#patchnote").append(`<h6
    class="card-subtitle mb-2 text-start"
    style="color: rgb(255, 255, 255)"
  >
    &#x2022; ${PatchNotes}
  </h6>`);
  }

  if (event.action == "SetStatus") {
    $("#health_bar").html(`<div
    class="progress"
    id="health_bar"
    role="progressbar"
    aria-label="Example with label"
    aria-valuenow="0"
    aria-valuemin="0"
    aria-valuemax="100"
    >
    <div class="progress-bar" style="width: ${event.values.healthBar}%">
    ${event.values.healthBar}%
    </div>
    </div>`);
    $("#Thirst_bar").html(`<div
    class="progress"
    id="Thirst_bar"
    role="progressbar"
    aria-label="Example with label"
    aria-valuenow="0"
    aria-valuemin="0"
    aria-valuemax="100"
    >
    <div class="progress-bar" style="width: ${event.values.drinkBar}%">
    ${event.values.drinkBar}%
    </div>
    </div>`);
    $("#Hunger_bar").html(`<div
      class="progress"
      id="Hunger_bar"
      role="progressbar"
      aria-label="Example with label"
      aria-valuenow="0"
      aria-valuemin="0"
      aria-valuemax="100">
    <div class="progress-bar" style="width: ${event.values.foodBar}%">
    ${event.values.foodBar}%
     </div>
    </div>`);
  }

  if (event.action == "Updateplaytime") {
    var playHour = event.playHour;
    var playMinutes = event.playMinute;

    $("#Totaltime").html(
      `<span id="Totaltime">0${playHour}H : ${playMinutes}M</span>`
    );
  }

  if (event.action == "closeui") {
    $(".main-container").css("display", "none");
  }
});

document.addEventListener("keydown", (event) => {
  if (event.keyCode == 27) {
    $(".main-container").css("display", "none");
    $.post("https://SY_PauseMenu/close");
  }
});

$("#player-info").click(function (e) {
  e.preventDefault();
  $(".main-content").css("display", "none");
  $(".player-info-card").addClass("animate__animated animate__zoomIn");
  $(".player-info-card").css("display", "block");
});

$("#report-btn").click(function (e) {
  e.preventDefault();
  $(".main-content").css("display", "none");
  $(".report-card").addClass("animate__animated animate__zoomIn");
  $(".report-card").css("display", "block");
});

$("#back_mainMenu").click(function (e) {
  e.preventDefault();
  $(".main-content").addClass("animate__animated animate__zoomIn");
  $(".main-content").css("display", "flex");
  $(".player-info-card").css("display", "none");
});

$("#back_mainMenu_fr_report").click(function (e) {
  e.preventDefault();
  $(".main-content").addClass("animate__animated animate__zoomIn");
  $(".main-content").css("display", "flex");
  $(".report-card").css("display", "none");
});

$("#setting").click(function (e) {
  e.preventDefault();
  $.post("https://SY_PauseMenu/settings");
});
$("#map").click(function (e) {
  e.preventDefault();
  $.post("https://SY_PauseMenu/map");
});
$("#resume").click(function (e) {
  e.preventDefault();
  $.post("https://SY_PauseMenu/resume");
});
$("#keybind").click(function (e) {
  e.preventDefault();
  $.post("https://SY_PauseMenu/keybind");
});
$("#exit").click(function (e) {
  e.preventDefault();
  $.post("https://SY_PauseMenu/exit");
});

// report form

$("#report_btn").click(function (e) {
  e.preventDefault();
  var type = document.getElementById("report_type");
  var reportType = type.options[type.selectedIndex].text;
  var description = document.getElementById("report_text");
  var reportText = description.value;
  var subject = document.getElementById("report_suggestion");
  var subjectText = subject.value;
  if (subjectText !== "") {
    fetchNui("Report", { reportType, reportText, subjectText });
  }
  subject.value = "";
  description.value = "";
});

$("#ooc_btn").click(function (e) {
  e.preventDefault();
  var text = document.getElementById("ooc_text");
  var oocText = text.value;
  if (oocText !== "") {
    fetchNui("ooc", { oocText });
  }
  text.value = "";
});
