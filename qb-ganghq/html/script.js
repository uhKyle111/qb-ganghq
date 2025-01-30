window.addEventListener("message", function(event) {
    if (event.data.action === "updateGangData") {
        document.getElementById("members").innerText = JSON.stringify(event.data.data.members);
        document.getElementById("businesses").innerText = JSON.stringify(event.data.data.businesses);
        document.getElementById("missions").innerText = JSON.stringify(event.data.data.missions);
    }
});

function modifyMember(action, gang, playerId) {
    fetch(`https://${GetParentResourceName()}/modifyMember`, {
        method: "POST",
        body: JSON.stringify({ action, gang, playerId }),
    });
}

function createBusiness(gang, businessType) {
    fetch(`https://${GetParentResourceName()}/createBusiness`, {
        method: "POST",
        body: JSON.stringify({ gang, businessType }),
    });
}
