
var w = 1200;
var h = 800;
var ticker_input = 'ABBV';


    function makeCircleTwo(dataset) {
      // d3.selectAll("svg").remove();

      var rScale = d3.scale.pow()
                    .domain([0,1050])
                    .range([60, 275]);

      var svg = d3.select("body")
  			          .append("svg")
  			          .attr("width", w)
  			          .attr("height", h);
      		
      var circle = svg.selectAll("circle")
      						    .data([0])
      						    .enter()
      						    .append("circle");
      		
      circle
      	.attr("cx", 400)
      	.attr("cy", h/2 - 250)
      	.attr("r", rScale(dataset[0][6]))
      	.attr("fill", "#2980b9")
      	.attr("fill-opacity", .7);

      var ellipse = svg.selectAll("ellipse")
                      .data([0])
                      .enter()
                      .append("ellipse");

      ellipse
        .attr("cx", 400)
        .attr("cy", h/2 + 43)
        .attr("rx", 75)
        .attr("ry", 25)
        .attr("fill-opacity", .2);

      var text = svg.selectAll("text")
        .data([0])
        .enter()
        .append("text");
        
      text
        .text(dataset[0][0])
        .attr("x", 455)
        .attr("y", h/2 - 250)
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "white" );

  
      circle
        .transition().attr("cx", 500).duration(1000).ease("elastic").each("end", trans);

      ellipse
        .transition().attr("cx", 500).duration(1000).ease("elastic")


      function trans() {
       dataset.forEach(function(d, i) {
        circle.transition().duration(10).delay(i * 10)
          .attr("r", rScale(d[6])) 
          .attr("fill", function() {
            if (rScale(d[6]) < 130) {
              return "#2980b9"
            } else if (rScale(d[6]) > 210){
              return "#f1c40f"
            } else if (rScale(d[6]) > 240) {
              return "#d35400"
            } else {
              return "#c0392b"
            }
           });
       
          // .attr("fill", "#"+((1<<24)*Math.random()|0).toString(16))

        ellipse.transition().duration(10).delay(i * 10)
          .attr("rx", rScale(d[6]))

        text.transition().duration(10).delay(i * 10)
          .text(d[0])
        });
      }

      var overlay = svg.append("rect")
        .attr("class", "overlay")
        .attr("x", 800)
        .attr("y", h/2 - 350)
        .attr("width", 200)
        .attr("height", 200)
        .attr('fill-opacity', 0)
        .attr("fill", "#2ecc71")
        .on("mouseover", enableInteraction);
  
      var box = overlay.node().getBBox();
  
    
      console.log(dataset[0][6]);
      console.log(dataset[dataset.length - 1][6]);
      console.log(box.x);
      console.log(box.x + box.width);
    

      // mouseover to change animation.
      function enableInteraction() {
        
        var boxScale = d3.scale.linear()
            .domain([200, box.x + box.width])
            .range([0, dataset.length - 1])
            .clamp(true);

        // Cancel the current transitions.
        circle.transition().duration(0);
        text.transition().duration(0);
        ellipse.transition().duration(0);

        overlay
            .on("mouseover", mouseover)
            .on("mouseout", mouseout)
            .on("mousemove", mousemove)
            .on("touchmove", mousemove);

        
        function mouseover() {
          console.log('yo');
          circle.classed("active", true);
        }

        function mouseout() {
          console.log("yo i'm out");
          circle.classed("active", false);
        }

        function mousemove() {
          // console.log('yo move');
          // console.log(Math.floor(boxScale(d3.mouse(this)[0])));
          displayChange(Math.floor(boxScale(d3.mouse(this)[0])));
        }
      
    // Updates the display to show the specified date and size.
        function displayChange(index) {
          text.text(dataset[index][0]);
          circle.attr("r", rScale(dataset[index][6]));
          ellipse.attr("rx", rScale(dataset[index][6]));
        }
      }
    }

