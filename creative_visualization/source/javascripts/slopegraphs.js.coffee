class HealthcareSlopegraph
  maxHeight: 800
  lineHeight: 16
  constructor: (@data, @svg) ->
    @initialYPos = @maxHeight/4

  draw: =>
    @_drawColumnLabels()
    @_drawCountryList()
    @_drawLifeExpectancy()
    @_drawPercentGDP()
    @_drawLines()

  _drawColumnLabels: ->
    columnLabels = ['Country', 'Avg Life Expectancy', '% GDP Spent on Healthcare']
    columnPosition = [10, 150, 400]
    for c, i in columnLabels
      @svg.append('text')
        .attr('x', columnPosition[i])
        .attr('y', @lineHeight)
        .text(c)
        .classed('table-header', true)

  _drawCountryList: ->
    @svg.selectAll('text.country-name')
      .data(@_sortByLifeExpectancy()).enter()
      .append('text')
      .attr('x', 10)
      .attr('y', (d, i) => i * @lineHeight + @initialYPos)
      .text((d) -> d.country)
      .classed('country-name', true)

  _drawLifeExpectancy: ->
    @svg.selectAll('text.life-expectancy')
      .data(@_sortByLifeExpectancy()).enter()
      .append('text')
      .attr('x', 150)
      .attr('y', (d, i) => i * @lineHeight + @initialYPos)
      .text((d, i) -> d['life expectancy'])
      .classed('life-expectancy', true)

  _drawPercentGDP: ->
    existingPos = []
    maxBoundary = 0.3
    @svg.selectAll('text.percent-gdp')
      .data(@_percentGDPCondensed()).enter()
      .append('text')
      .attr('x', 400)
      .text((d) =>
        if _.find(existingPos, (currentGDP) => d < currentGDP + maxBoundary && d > currentGDP - maxBoundary)
          return null

        existingPos.push(d)
        d
      )
      .attr('y', (d) => @_percentGDPScale()(d))
      .classed('percent-gdp', true)

  _drawLines: =>
    @svg.selectAll('line.slopelines')
      .data(@_sortByLifeExpectancy()).enter()
      .append('line')
      .attr('x1', 200)
      .attr('x2', 390)
      .attr('y1', (d, i) => i * @lineHeight + @initialYPos)
      .attr('y2', (d) => @_findGDPPosition(d) - @lineHeight/2)
      .attr('stroke', 'black')
      .classed('slopelines', true)

  _findGDPPosition: (d) =>
    @_percentGDPScale()(d['percent gdp on health'])

  _percentGDPCondensed: =>
    roundGDP = (d) ->
      Math.round(d['percent gdp on health']*10)/10

    @gdpCondensed ||= _.map(@data, roundGDP)

  _sortByLifeExpectancy: ->
    @sortedByLifeExpectancy ||= _.sortBy @data, (d) ->
      parseFloat d['life expectancy']
    _.clone(@sortedByLifeExpectancy).reverse()

  _sortByPercentGDP: ->
    @sortedByPercentGDP ||= _.sortBy @data, (d) ->
      parseFloat d['percent gdp on health']
    _.clone(@sortedByPercentGDP).reverse()

  _percentGDPScale: ->
    range = d3.extent(@data, (d) -> parseFloat d['percent gdp on health']).reverse()
    @gdpYScale ||=  d3.scale.linear().domain(range).range([@lineHeight*3, 800])

d3.csv 'data/2011_life_expectancy_vs_health_care_spending.csv', (data) ->
  svg = d3.select('.graph')
    .append('svg')
    .attr('height', 850)
    .append('g')

  slopegraph = new HealthcareSlopegraph(data, svg)
  slopegraph.draw()
