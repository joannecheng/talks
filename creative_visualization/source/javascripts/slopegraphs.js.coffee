class HealthcareSlopegraph
  maxHeight: 800
  lineHeight: 16
  constructor: (@data, @svg) ->
    @initialYPos = @maxHeight/4

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
    @svg.selectAll('text.percent-gdp')
      .data(@_percentGDPCondensed()).enter()
      .append('text')
      .attr('x', 400)
      .text((d) =>
        if _.find(existingPos, (currentGDP) => d < currentGDP + 0.2 && d > currentGDP - 0.2)
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
      .attr('y2', (d) => @_findGDPPosition(d) - 6)
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
    @gdpYScale ||=  d3.scale.linear().domain(range).range([12, 800])

d3.csv 'data/2011_life_expectancy_vs_health_care_spending.csv', (data) ->
  svg = d3.select('.graph')
    .append('svg')
    .attr('height', 850)
    .append('g')

  slopegraph = new HealthcareSlopegraph(data, svg)
  slopegraph.draw()
