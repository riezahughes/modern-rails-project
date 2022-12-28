$(document).ready(function() {
  var payments_breakdown = $('#payments-breakdown');
  if (payments_breakdown.length) {
    $.ajax({
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: '/payments/breakdown' + window.location.search,
      dataType: 'json',
      success: function(data) {
        draw(data);
      },
      error: function(result) {
        console.log(result);
      }
    });
  }

  function draw(data) {

    var svg = d3.select("#payments-breakdown"),
        width = +svg.attr("width"),
        height = +svg.attr("height"),
        radius = Math.min(width, height) / 2,
        g = svg.append("g").attr("transform", "translate(" + ((width / 2) - 100) + "," + height / 2 + ")");

    var color = d3.scaleOrdinal(d3.schemeCategory20);

    var pie = d3.pie()
        .sort(function(a, b) {
      		return b.value - a.value;
      	})
        .value(function(data) {
          return data.value;
         });

    var path = d3.arc()
        .outerRadius(radius - 10)
        .innerRadius(0);

    var arc = g.selectAll(".arc")
      .data(pie(d3.entries(data)))
      .enter().append("g")
        .attr("class", "arc");

    arc.append("path")
        .attr("d", path)
        .attr("fill", function(data) { return color(data.value); });

    arc.append('rect')
      .attr("transform", function(data) { return "translate(" + (radius + 10) + "," + ((data.index * 18) - radius + 18) + ")"; })            .attr("width", 10)
            .attr("height", 10).attr("width", 10)
            .style("fill",function(data) { return color(data.value); });

    arc.append("text")
        .attr("transform", function(data) { return "translate(" + (radius + 25) + "," + ((data.index * 18) - radius + 28) + ")"; })
        .text(function(data) {
          return data.data.key + ": £" + (data.value/100).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');;
        });
  }

});
