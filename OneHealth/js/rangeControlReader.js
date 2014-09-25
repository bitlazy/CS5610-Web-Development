// Change the value of the range label based on the value of the premium_range control's position
function rangechange(type) {
    var premium = document.getElementById(type + '_premium_range').value;

    document.getElementById(type + '_range_span').innerText = premium + '$';
    document.getElementById('hidden').value = premium;

}