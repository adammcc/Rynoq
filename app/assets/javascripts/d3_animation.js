//Width and height
var w = 600;
var h = 800;

var dataset = [
   ["2013-11-08", "1008.75", "1018.50", "1008.50", "1016.03", "1290800", "1016.03"],
   ["2013-11-07", "1022.61", "1023.93", "1007.64", "1007.95", "1679600", "1007.95"],
   ["2013-11-06", "1025.60", "1027.00", "1015.37", "1022.75", "912900", "1022.75"],
   ["2013-11-05", "1020.35", "1031.65", "1017.42", "1021.52", "1181400", "1021.52"],
   ["2013-11-04", "1031.50", "1032.37", "1022.03", "1026.11", "1138800", "1026.11"],
   ["2013-11-01", "1031.79", "1036.00", "1025.10", "1027.04", "1283300", "1027.04"],
   ["2013-10-31", "1028.93", "1041.52", "1023.97", "1030.58", "1640000", "1030.58"],
   ["2013-10-30", "1037.43", "1037.51", "1026.00", "1030.42", "1324100", "1030.42"],
   ["2013-10-29", "1019.10", "1036.94", "1013.50", "1036.24", "1605000", "1036.24"],
   ["2013-10-28", "1015.20", "1023.43", "1012.99", "1015.00", "1158700", "1015.00"],
   ["2013-10-25", "1028.82", "1028.82", "1010.74", "1015.20", "2030500", "1015.20"],
   ["2013-10-24", "1031.87", "1040.57", "1024.80", "1025.55", "2092100", "1025.55"],
   ["2013-10-23", "1001.00", "1034.75", "1000.63", "1031.41", "2663200", "1031.41"],
   ["2013-10-22", "1005.00", "1013.00", "995.79", "1007.00", "2208600", "1007.00"],
   ["2013-10-21", "1011.46", "1019.00", "999.55", "1003.30", "3628300", "1003.30"],
   ["2013-10-18", "976.58", "1015.46", "974.00", "1011.41", "11566400", "1011.41"],
   ["2013-10-17", "892.99", "896.90", "885.73", "888.79", "4256600", "888.79"],
   ["2013-10-16", "885.87", "898.33", "884.01", "898.03", "2007600", "898.03"],
   ["2013-10-15", "875.76", "885.63", "874.00", "882.01", "1591900", "882.01"],
   ["2013-10-14", "866.66", "876.25", "865.39", "876.11", "1243600", "876.11"],
   ["2013-10-11", "866.03", "873.48", "865.30", "871.99", "1408900", "871.99"]
 ]


var information = {company_name: 'Google inc.', ticker: 'GOOG', description: 'Google Inc. (Google) is a global technology company. The Company’s business is primarily focused around key areas, such as search, advertising, operating systems and platforms, enterprise and hardware products. The Company generates revenue primarily by delivering online advertising. The Company provides its products and services in more than 100 languages and in more than 50 countries, regions, and territories. The Company’s Motorola business consists of two segments: Mobile segment and Home segment. The Mobile segment is focused on mobile wireless devices and related products and services. The Home segment is focused on technologies and devices that provide video entertainment services to consumers by enabling subscribers to access a variety of interactive digital television services. Effective September 16, 2013, Google Inc acquired Bump Technologies Inc. Effective October 22, 2013, Google Inc acquired FlexyCore, a developer of software.'}


var rScale = d3.scale.linear()
                .domain([0,1050])
                .range([0,275]);


var svg = d3.select("body")
			          .append("svg")
			          .attr("width", w)
			          .attr("height", h);
		
var circle = svg.selectAll("circle")
						    .data(dataset.reverse())
						    .enter()
						    .append("circle");
		
circle
	.attr("cx", -100)
	.attr("cy", h/2 - 75)
	.attr("r", rScale(30))
	.attr("fill", "#2ecc71")
	.attr('fill-opacity', 0.1)


var text = svg.selectAll("text")
  .data(dataset)
  .enter()
  .append("text")
  

text
 	.text(function(d) {
     return d[0];
 		})
	.attr("x", -100)
  .attr("y", h/2 - 75)
  .attr("font-family", "sans-serif")
  .attr("font-size", "20px")
  .attr("fill", "white" );


  dataset.forEach(function(d, i) {
    circle.transition().duration(1000).delay(i * 1000)
      .attr("r", rScale(d[6]))
      // .attr("fill", "#"+((1<<24)*Math.random()|0).toString(16))
      // .attr('fill-opacity', Math.random())
      .attr("cx", 300)
      .ease("elastic");
    text.transition().duration(1000).delay(i * 1000)
	    .text(d[0])
	    .attr("x", 255)
	});
