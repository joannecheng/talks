class HealthcareSlopegraph
  constructor: (@data, @svg) ->

  draw: =>
    @_drawCountryList()
    @_drawLifeExpectancy()
    @_drawPercentGDP()
    @_drawLines()

  _drawCountryList: ->
    @svg.selectAll('text.country-name')
      .data(@_sortByLifeExpectancy()).enter()
      .append('text')
      .attr('x', 10)
      .attr('y', (d, i) -> i * 14 + 12)
      .text((d) -> d.country)
      .classed('country-name', true)

  _drawLifeExpectancy: ->
    @svg.selectAll('text.life-expectancy')
      .data(@_sortByLifeExpectancy()).enter()
      .append('text')
      .attr('x', 150)
      .attr('y', (d, i) -> i * 14 + 12)
      .text((d) -> d['life expectancy'])
      .classed('life-expectancy', true)

  _drawPercentGDP: ->
    @svg.selectAll('text.percent-gdp')
      .data(@_sortByPercentGDP()).enter()
      .append('text')
      .attr('x', 400)
      .attr('y', (d, i) -> i * 14 + 12)
      .text((d) -> d['percent gdp on health'])
      .classed('percent-gdp', true)

  _drawLines: =>
    @svg.selectAll('line.slopelines')
      .data(@_sortByLifeExpectancy()).enter()
      .append('line')
      .attr('x1', 200)
      .attr('x2', 390)
      .attr('y1', (d, i) -> i * 14 + 6)
      .attr('y2', (d) =>
        @_findGDPPosition(d) * 14 + 6)
      .attr('stroke', 'black')
      .classed('slopelines', true)

  _findGDPPosition: (d) =>
    _.indexOf(@_sortByPercentGDP(), d)

  _sortByLifeExpectancy: ->
    @sortedByLifeExpectancy ||= _.sortBy @data, (d) ->
      parseFloat d['life expectancy']
    _.clone(@sortedByLifeExpectancy).reverse()

  _sortByPercentGDP: ->
    @sortedByPercentGDP ||= _.sortBy @data, (d) ->
      parseFloat d['percent gdp on health']
    _.clone(@sortedByPercentGDP).reverse()

d3.csv 'data/2011_life_expectancy_vs_health_care_spending.csv', (data) ->
  svg = d3.select('.graph')
    .append('svg')
    .append('g')

  slopegraph = new HealthcareSlopegraph(data, svg)
  slopegraph.draw()
