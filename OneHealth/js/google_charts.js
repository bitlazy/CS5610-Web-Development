// Call the google chart's visualization library and the chart package
google.load("visualization", "1", { packages: ["corechart"] });
google.setOnLoadCallback(drawChart);

// get the HCAHPS survey responses from the hidden controls and form a data table
function drawChart() {
    var data1 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden1').value), 'green'],
        ['Usually', Number(document.getElementById('hidden2').value), 'orange'],
        ['Never', Number(document.getElementById('hidden3').value), 'red']

    ]);

    var data2 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden4').value), 'green'],
        ['Usually', Number(document.getElementById('hidden5').value), 'orange'],
        ['Never', Number(document.getElementById('hidden6').value), 'red']

    ]);

    var data3 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden7').value), 'green'],
        ['Usually', Number(document.getElementById('hidden8').value), 'orange'],
        ['Never', Number(document.getElementById('hidden9').value), 'red']

    ]);

    var data4 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden10').value), 'green'],
        ['Usually', Number(document.getElementById('hidden11').value), 'orange'],
        ['Never', Number(document.getElementById('hidden12').value), 'red']

    ]);

    var data5 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden13').value), 'green'],
        ['Usually', Number(document.getElementById('hidden14').value), 'orange'],
        ['Never', Number(document.getElementById('hidden15').value), 'red']

    ]);

    var data6 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Always', Number(document.getElementById('hidden16').value), 'green'],
        ['Usually', Number(document.getElementById('hidden17').value), 'orange'],
        ['Never', Number(document.getElementById('hidden18').value), 'red']

    ]);

    var data7 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['9-10', Number(document.getElementById('hidden19').value), 'green'],
        ['7-8', Number(document.getElementById('hidden20').value), 'orange'],
        ['6 or Lower', Number(document.getElementById('hidden21').value), 'red']

    ]);


    var data8 = google.visualization.arrayToDataTable([

        ['Response', 'Percentage', { role: 'style' }],
        ['Definitely', Number(document.getElementById('hidden22').value), 'green'],
        ['Probably', Number(document.getElementById('hidden23').value), 'orange'],
        ['Never', Number(document.getElementById('hidden24').value), 'red']

    ]);

    var options = { legend: { position: "none" } };

    // set the datas to the chart containers in the page
    var chart = new google.visualization.BarChart(document.getElementById('Div1'));
    chart.draw(data1, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div2'));
    chart.draw(data2, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div3'));
    chart.draw(data3, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div4'));
    chart.draw(data4, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div5'));
    chart.draw(data5, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div6'));
    chart.draw(data6, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div7'));
    chart.draw(data7, options);

    var chart = new google.visualization.BarChart(document.getElementById('Div8'));
    chart.draw(data8, options);
}
// End of charts