
window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action === 'updateHUD') {
    document.getElementById('health').style.display = data.health !== null ? 'flex' : 'none';
    document.getElementById('shield').style.display = data.armor !== null ? 'flex' : 'none';
    document.getElementById('food').style.display = data.hunger !== null ? 'flex' : 'none';
    document.getElementById('thirst').style.display = data.thirst !== null ? 'flex' : 'none';
    if (data.health !== null) {
      document.getElementById('health-bar').style.width = `${data.health}%`;
    }
    if (data.armor !== null) {
      document.getElementById('shield-bar').style.width = `${data.armor}%`;
    }
    if (data.hunger !== null) {
      document.getElementById('food-bar').style.width = `${data.hunger}%`;
    }
    if (data.thirst !== null) {
      document.getElementById('thirst-bar').style.width = `${data.thirst}%`;
    }
  }
});
