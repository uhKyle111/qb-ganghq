(() => {
  "use strict";

  /**
   * Helper: Convert numeric reputation to a rank.
   * @param {number} rep - The reputation number.
   * @returns {string} - The corresponding rank.
   */
  const getRankFromRep = (rep) => {
    if (rep < 50) return "Rookie";
    else if (rep < 100) return "Novice";
    else if (rep < 150) return "Seasoned";
    else if (rep < 200) return "Veteran";
    else return "Boss";
  };

  /**
   * Updates a list element with new items.
   * @param {string} listId - The ID of the list element.
   * @param {Array} items - Array of items to display.
   * @param {function} formatter - Function to format each item.
   */
  const updateList = (listId, items, formatter) => {
    const list = document.getElementById(listId);
    list.innerHTML = "";
    items.forEach((item) => {
      const li = document.createElement("li");
      li.textContent = formatter(item);
      list.appendChild(li);
    });
  };

  /**
   * Updates the mission UI.
   * @param {object} data - The mission data.
   */
  const updateMissionUI = (data) => {
    document.getElementById("mission-objective").textContent = data.objective || "Waiting for mission...";
    document.getElementById("mission-timer").textContent = data.timer || "--:--";
    document.getElementById("mission-description").textContent = data.description || "...";
    document.getElementById("mission-item").textContent = data.item || "No item assigned";
  };

  /**
   * Closes the dashboard and notifies the parent resource.
   */
  const closeDashboard = () => {
    document.getElementById("dashboard").classList.add("hidden");
    document.body.classList.add("hidden");

    fetch(`https://${GetParentResourceName()}/closePanel`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
    }).catch((err) => console.error("Error closing panel:", err));

    if (typeof SetNuiFocus === "function") {
      SetNuiFocus(false, false);
    }
    document.body.style.cursor = "auto";
  };

  document.addEventListener("DOMContentLoaded", () => {
    // Listen for messages (e.g., from FiveM)
    window.addEventListener("message", (event) => {
      const { action, data, members, businesses } = event.data;
      switch (action) {
        case "openDashboard":
          document.getElementById("dashboard").classList.remove("hidden");
          document.body.classList.remove("hidden");
          if (typeof SetNuiFocus === "function") {
            SetNuiFocus(true, true);
          }
          document.body.style.cursor = "pointer";
          break;
        case "closeDashboard":
          closeDashboard();
          break;
        case "updateOverview":
          document.getElementById("gang-name").textContent = `Gang: ${data.gangName}`;
          document.getElementById("gang-funds").textContent = `Funds: $${data.bankBalance}`;
          document.getElementById("gang-rep").textContent = `Reputation: ${data.reputation} (${getRankFromRep(data.reputation)})`;
          break;
        case "updateMissions":
          updateMissionUI(data);
          break;
        case "updateMembers":
          updateList("members-list", members, (member) => `${member.name} - Rank: ${member.rank}`);
          break;
        case "updateBusinesses":
          updateList("business-list", businesses, (business) => `${business.name} - Income: $${business.income}`);
          break;
        default:
          console.warn("Unknown action:", action);
          break;
      }
    });

    // Setup sidebar navigation
    document.querySelectorAll(".dashboard-sidebar nav ul li").forEach((navItem) => {
      navItem.addEventListener("click", function () {
        document.querySelectorAll(".dashboard-sidebar nav ul li").forEach((item) =>
          item.classList.remove("active")
        );
        document.querySelectorAll(".content-section").forEach((section) =>
          section.classList.remove("active")
        );
        this.classList.add("active");
        const targetSection = document.getElementById(this.dataset.target);
        if (targetSection) targetSection.classList.add("active");
      });
    });

    // Close UI when the Escape key is pressed.
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") closeDashboard();
    });

    // Close UI when clicking the close button.
    const btnClose = document.querySelector(".btn-close") || document.querySelector(".close-btn");
    if (btnClose) {
      btnClose.addEventListener("click", closeDashboard);
    }

    // Mission Start Handler
    const startMissionBtn = document.getElementById("start-mission");
    if (startMissionBtn) {
      startMissionBtn.addEventListener("click", () => {
        fetch(`https://${GetParentResourceName()}/startMission`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ start: true })
        }).catch((err) => console.error("Error starting mission:", err));

        startMissionBtn.classList.add("hidden");
        const completeMissionBtn = document.getElementById("complete-mission");
        if (completeMissionBtn) {
          completeMissionBtn.classList.remove("hidden");
        }
      });
    }

    // Mission Completion Handler
    const completeMissionBtn = document.getElementById("complete-mission");
    if (completeMissionBtn) {
      completeMissionBtn.addEventListener("click", () => {
        fetch(`https://${GetParentResourceName()}/completeMission`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ complete: true })
        }).catch((err) => console.error("Error completing mission:", err));

        completeMissionBtn.classList.add("hidden");
        if (startMissionBtn) {
          startMissionBtn.classList.remove("hidden");
        }
      });
    }
  });
})();
