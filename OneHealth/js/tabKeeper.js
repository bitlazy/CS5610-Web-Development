function load() {
    var currentTab = document.getElementById('currentTab');
    if (currentTab.value)
        document.getElementById(currentTab.value).click();
}

window.onload = load;




$(document).ready(function () {
    $('#Tab').easyResponsiveTabs({
        type: 'default',
        width: 'auto',
        fit: true,
        closed: 'accordion',
        activate: function (event) { }
    });

});