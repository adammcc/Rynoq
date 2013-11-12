
var w = 600;
var h = 800;
var ticker_input = 'ABBV';

$(function() {
  getData()

  $("#stock_ticker").on('change', function() {
    console.log('yo')
    ticker_input = $('#stock_ticker option:selected').val();
    window.location = '/stocks/' + ticker_input
    // var win = window.open("stocks/" + location,'_self',false)
  
  });
});

    // console.log(ticker_input)
    function getData() {
      $.ajax({
        type: "GET",
        dataType: "json",
        url: "/stocks/" + ticker_input,
        success: function(data){
          console.log(data)
          dataset = data
          makeCircle(dataset)
        }
      });
    }

    function makeCircle(dataset) {
      d3.selectAll("svg").remove();

      var rScale = d3.scale.linear()
                    .domain([0,1050])
                    .range([60,275]);

      var svg = d3.select("body")
  			          .append("svg")
  			          .attr("width", w)
  			          .attr("height", h);
      		
      var circle = svg.selectAll("circle")
      						    .data([0])
      						    .enter()
      						    .append("circle");
      		
      circle
      	.attr("cx", -100)
      	.attr("cy", h/2 - 250)
      	.attr("r", rScale(dataset[0][6]))
      	.attr("fill", "#2ecc71")
      	.attr("fill-opacity", .7);

      var ellipse = svg.selectAll("ellipse")
                      .data([0])
                      .enter()
                      .append("ellipse");

      ellipse
        .attr("cx", -100)
        .attr("cy", h/2 + 43)
        .attr("rx", 75)
        .attr("ry", 25)
        .attr("fill-opacity", .2);

      var text = svg.selectAll("text")
        .data("Start")
        .enter()
        .append("text");
        
      text
        .text(dataset[0][0])
        .attr("x", 255)
        .attr("y", h/2 - 250)
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "white" );

      circle
        .transition().attr("cx", 300).duration(4000).ease("elastic").each("end", trans);

      ellipse
        .transition().attr("cx", 300).duration(4000).ease("elastic")
      
      function trans() {
       dataset.forEach(function(d, i) {
        // console.log(d[6])
        circle.transition().duration(10).delay(i * 10)
          .attr("r", rScale(d[6]))
          // .attr("fill", "#"+((1<<24)*Math.random()|0).toString(16))

        ellipse.transition().duration(10).delay(i * 10)
          .attr("rx", rScale(d[6]))

          // .attr("cx", 300)
          
          // .attr('fill-opacity', Math.random())
          // .ease("elastic");
        text.transition().duration(10).delay(i * 10)
          .text(d[0])
          // .attr("x", 255)
        });
      }
    }
// });
