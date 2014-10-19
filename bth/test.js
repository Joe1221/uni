
var gview, greal, svg, zoom, xscale, yscale, xAxis, yAxis, x, y;


function drawPolynomialPath (expr) {
  var n = 100;
  //var expr = '- 3*z^5 + 2*z^3 + z';

  var a = math.complex(-1, -1),
      b = math.complex(1, -1),
      c = math.complex(1, 1),
      d = math.complex(-1, 1);

  var data1 = d3.range(n+1).map(function (i) {
    return math.add(a, math.complex(2*i / n, 0));
  });
  var data2 = d3.range(n+1).map(function (i) {
    return math.add(b, math.complex(0, 2*i / n));
  });
  var data3 = d3.range(n+1).map(function (i) {
    return math.add(c, math.complex(-2*i / n, 0));
  });
  var data4 = d3.range(n+1).map(function (i) {
    return math.add(d, math.complex(0, -2*i / n));
  });

  function evalexpr (z) {
    fz = math.complex(math.eval(expr, {z: z}));
    return fz;
  }
  dataf1 = data1.map(evalexpr);
  dataf2 = data2.map(evalexpr);
  dataf3 = data3.map(evalexpr);
  dataf4 = data4.map(evalexpr);

  var linef = d3.svg.line()
    .x(function(d) { return d.re })
    .y(function(d) { return d.im })
    .interpolate('basis');

  [dataf1, dataf2, dataf3, dataf4].map(function (data) {
    greal.append('path')
      .attr('class', 'polypath')
      .datum(data)
      .attr('d', linef);
  });
}




$(function () {




var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var widthDomain = (width / Math.min(width, height)) * 1.5;
var heightDomain = (height / Math.min(width, height)) * 1.5;


x = d3.scale.linear()
    .domain([-widthDomain, widthDomain])
    .range([0, width]);

y = d3.scale.linear()
    .domain([-heightDomain, heightDomain])
    .range([height, 0]);

xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    .tickSize(-height);

yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickSize(-width);

zoom = d3.behavior.zoom()
    .x(x)
    .y(y)
    //.scaleExtent([1, 10])
    .on("zoom", zoomed);

//zoom.translate([380, 180]).scale(100);

svg = d3.select("#view").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(zoom);

svg.append("rect")
    .attr("width", width)
    .attr("height", height);

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

// transforms the view (pan/zoom)
gview = svg.append('g')

xscale = (x.range()[1] - x.range()[0]) / (x.domain()[1] - x.domain()[0]);
yscale = (y.range()[1] - y.range()[0]) / (y.domain()[1] - y.domain()[0]);
// transforms the coordinate system to match the axis
greal = gview.append('g')
  .attr('transform', 'translate(' + (x.range()[0]) + ',' + (y.range()[0]) + ')'
      + 'scale(' + xscale + ',' + ( yscale) + ') translate(' + (-1*x.domain()[0]) + ',' + (-1*y.domain()[0]) + ')')

greal.append('path')
  .attr('class', 'y coordaxis')
  .attr('d', 'M0 ' + y.domain()[0] + 'L0 ' + y.domain()[1]);
greal.append('path')
  .attr('class', 'x coordaxis')
  .attr('d', 'M' + x.domain()[0] + ' 0L' + x.domain()[1] + ' 0');

zoomed();


$('#polynomial').on('change', function () {
  try {
    math.eval($(this).val(), {z: 0});

    $('.polypath').remove();
    drawPolynomialPath($(this).val());
    $(this).css('color', 'black');
  } catch (err) {
    $(this).css('color', 'red');
  }
});
$('#polynomial').val('0.5(z^4 + z)').change().focus();

});

function zoomed() {
  // transform view
  gview.attr('transform',
      'translate(' + zoom.translate() + ') scale(' + zoom.scale() + ')');
  gview.style('stroke-width', 1 / zoom.scale() / xscale);

  // redraw axes
  svg.select(".x.axis").call(xAxis);
  svg.select(".y.axis").call(yAxis);

  // redraw coordinate axes
  svg.select('.y.coordaxis')
    .attr('d', 'M0 ' + y.domain()[0] + 'L0 ' + y.domain()[1]);
  svg.select('.x.coordaxis')
    .attr('d', 'M' + x.domain()[0] + ' 0L' + x.domain()[1] + ' 0');
}

