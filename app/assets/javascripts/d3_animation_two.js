
var w = 600;
var h = 800;
var ticker_input = 'ABBV';
var circle_two = null;
var ellipse_two;
var date_two;
var price_two;


    function makeCircleTwo(dataset) {
      // d3.selectAll("svg").remove();

      if (circle_two != null) {
        circle_two.transition().duration(0);
        date_two.transition().duration(0);
        price_two.transition().duration(0);
        ellipse_two.transition().duration(0);
      }

      var rScale = d3.scale.pow()
                    .domain([0,1050])
                    .range([60, 275]);

      var svg = d3.select("body")
  			          .append("svg")
  			          .attr("width", w)
  			          .attr("height", h);
      		
      circle_two = svg.selectAll("circle")
      						    .data([0])
      						    .enter()
      						    .append("circle");
      		
      circle_two
      	.attr("cx", 1400)
      	.attr("cy", h/2 - 165)
      	.attr("r", rScale(dataset[0][6]))
      	.attr("fill", "#2980b9")
      	.attr("fill-opacity", .7);

      ellipse_two = svg.selectAll("ellipse")
                      .data([0])
                      .enter()
                      .append("ellipse");

      ellipse_two
        .attr("cx", 1400)
        .attr("cy", h/2 + 128)
        .attr("rx", 75)
        .attr("ry", 25)
        .attr("fill-opacity", .1);

      date_two = svg.selectAll("text.date")
        .data([0])
        .enter()
        .append("text");
        
      date_two
        .attr("class", "date")
        .text(dataset[0][0])
        .attr("x", 1400)
        .attr("y", h/2 - 165)
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "white" );

     price_two = svg.selectAll("text.price")
        .data([0])
        .enter()
        .append("text");
        
      price_two
        .attr("class", "price")
        .text("$" + dataset[0][6])
        .attr("x", 1400)
        .attr("y", h/2 - 142)
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "white" );
  
      circle_two
        .transition().attr("cx", 850).duration(1000).ease("elastic").each("end", trans);

      ellipse_two
        .transition().attr("cx", 850).duration(1000).ease("elastic")

       date_two
        .transition().attr("x", 800).duration(1000).ease("elastic")

      price_two
        .transition().attr("x", 817).duration(1000).ease("elastic")

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

        ellipse_two.transition().duration(10).delay(i * 10)
          .attr("rx", rScale(d[6]))

        date_two.transition().duration(10).delay(i * 10)
          .text(d[0])

        price_two.transition().duration(10).delay(i * 10)
          .text("$" + d[6])
         });
      }

      var overlay_two = svg.append("rect")
        .attr("class", "overlay_two")
        .attr("x", 750)
        .attr("y", h/2 - 350)
        .attr("width", 200)
        .attr("height", 200)
        .attr('fill-opacity', 0)
        .attr("fill", "#2ecc71")
        .on("mouseover", enableInteraction);
  
      var box_two = overlay_two.node().getBBox();
  
    
      console.log(dataset[0][6]);
      console.log(dataset[dataset.length - 1][6]);
      console.log(box_two.x);
      console.log(box_two.x + box_two.width);
    

      // mouseover to change animation.
      function enableInteraction() {
        
        var boxScaleTwo = d3.scale.linear()
            .domain([750, box_two.x + box_two.width])
            .range([0, dataset.length - 1])
            .clamp(true);

        // Cancel the current transitions.
        circle_two.transition().duration(0);
        date_two.transition().duration(0);
        price_two.transition().duration(0);
        ellipse_two.transition().duration(0);

        overlay_two
            .on("mouseover", mouseoverTwo)
            .on("mouseout", mouseoutTwo)
            .on("mousemove", mousemoveTwo)
            .on("touchmove", mousemoveTwo);

        
        function mouseoverTwo() {
          console.log('yo');
          circle.classed("active", true);
        }

        function mouseoutTwo() {
          console.log("yo i'm out");
          circle_two.classed("active", false);
        }

        function mousemoveTwo() {
          // console.log('yo move');
          // console.log(Math.floor(boxScale(d3.mouse(this)[0])));
          displayChangeTwo(Math.floor(boxScaleTwo(d3.mouse(this)[0])));
        }
      
    // Updates the display to show the specified date and size.
        function displayChangeTwo(index) {
          date.text(dataset[index][0]);
          price_two.text("$" + dataset[index][6]);
          circle_two.attr("r", rScale(dataset[index][6]));
          ellipse_two.attr("rx", rScale(dataset[index][6]));
        }
      }
    }

