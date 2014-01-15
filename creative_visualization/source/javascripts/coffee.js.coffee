cupHeight = 35
cupWidth = 22
w = 800
h = 2400
spacing = 25
columnCount = parseInt(w/(cupWidth+20))
sugarSize = 10

calculatedXPos = (d, i) ->
  i%columnCount*(cupWidth+spacing)

d3.csv 'data/modified_responses.csv', (data) ->
  svg = d3.select('.visualization.coffee svg')

  g = svg.append('g')

  cups = g.selectAll('rect.cup-coffee')
    .data(data).enter()
    .append('rect')
    .attr('x', calculatedXPos)
    .attr('y', (d, i) ->
      parseInt(i/columnCount)*(cupHeight+spacing)
    )
    .attr('width', cupWidth)
    .attr('height', cupHeight)
    .attr('data-coffee-style', (d) -> d.coffeeStyle)
    .attr('class', (d, i) ->
      reMilk = /Milk/
      if reMilk.exec(d.coffeeStyle)
        return 'milk'
    )
    .classed('cup-coffee', true)

  sugar = g.selectAll('rect.sugar')
    .data(data).enter()
    .append('rect')
    .attr('x', (d, i) -> calculatedXPos(d, i) + cupWidth/4 - sugarSize)
    .attr('y', (d, i) ->
      parseInt(i/columnCount)*(cupHeight+spacing) + 5
    )
    .attr('width', sugarSize)
    .attr('height', sugarSize)
    .attr('fill', (d) ->
      reSugar = /Sugar/
      if reSugar.exec(d.coffeeStyle)
        return '#ffffff'
      'none'
    )

  cups.attr('transform', 'translate(10)')
  sugar.attr('transform', "translate(20, #{cupHeight/3 - 10})")
