var t = .5,
    delta = .01,
    points = [{x: 10, y: 250}, {x: 0, y: 0}, {x: 100, y: 0}, {x: 200, y: 250}, {x: 225, y: 125}],
    bezier = {},
    line = d3.svg.line().x(x).y(y),
    stroke = d3.scale.category20b(); // Color?

var vis = d3.select("#vissvg");
vis.append("g");

update();


vis.selectAll("circle.control")
    .data(points)
  .enter().append("circle") // for each control point
    .attr("class", "control")
    .attr("r", 7)
    .attr("cx", x).attr("cy", y)
    .call(d3.behavior.drag().origin(Object)
      .on("drag", function(d) {
        d.x = d3.event.x;
        d.y = d3.event.y;
        update();
        vis.selectAll("circle.control")
          .attr("cx", x)
          .attr("cy", y);
      }));

vis.append("text")
  .attr("class", "t")
  .attr("x", 300 / 2)
  .attr("y", 400)
  .attr("text-anchor", "middle");

d3.select("#vis").selectAll("div.controltext")
    .data(points)
  .enter().append("div")
    .attr("class", "controltext")
	.text(function(d, i) { return '$P_' + i + '$'});


/*var last = 0;
d3.timer(function(elapsed) {
  t = (t + (elapsed - last) / 5000) % 1;
  last = elapsed;
  update();
});*/

update();



function update() {
  var interpolation = vis.selectAll("g")
      .data(function(d) { return getLevels(5, t); });
  interpolation.enter().append("g")
      .style("fill", colour)
      .style("stroke", colour);



  var circle = interpolation.selectAll("circle")
      .data(Object);
  circle.enter().append("circle")
      .attr("r", 4);
  circle
      .attr("cx", x)
      .attr("cy", y);
	  console.log(circle);

  var path = interpolation.selectAll("path")
      .data(function(d) { return [d]; });
  console.log(path);
  path.enter().append("path")
      .attr("class", "line")
      .attr("d", line);
  path.attr("d", line);

  var curve = vis.selectAll("path.curve")
      .data(getCurve);
  curve.enter().append("path")
      .attr("class", "curve");
  curve.attr("d", line);

  var controltext = d3.select("#vis").selectAll("div.controltext");

  console.log(controltext);
  controltext
      .style("left", function(d) { return d.x + "px" })
	  .style("top", function(d) { return d.y + "px" });

  vis.selectAll("text.t")
      .text("t=" + t.toFixed(2));
}

function interpolate(d, p) {
  if (arguments.length < 2) p = t;
  var r = [];
  for (var i=1; i<d.length; i++) {
    var d0 = d[i-1], d1 = d[i];
    r.push({x: d0.x + (d1.x - d0.x) * p, y: d0.y + (d1.y - d0.y) * p});
  }
  return r;
}

function getLevels(d, t_) {
  if (arguments.length < 2) t_ = t;
  var x = [points.slice(0, d)];
  for (var i=1; i<d; i++) {
    x.push(interpolate(x[x.length-1], t_));
  }
  return x;
}

function getCurve(d) {
  var curve = bezier[d];
  if (!curve) {
    curve = bezier[d] = [];
    for (var t_=0; t_<=1; t_+=delta) {
      var x = getLevels(d, t_);
      curve.push(x[x.length-1][0]);
    }
  }
  return [curve.slice(0, t / delta + 1)];
}

function x(d) { return d.x; }
function y(d) { return d.y; }
function colour(d, i) {
  stroke(-i);
  return d.length > 1 ? stroke(i) : "red";
}

