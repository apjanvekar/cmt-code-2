#!/usr/bin/env ruby
require("chartdirector")

#/////////////////////////////////////////////////////////////////////////////////////////////////
# Copyright 2008 Advanced Software Engineering Limited
#
# ChartDirector FinanceChart class library
#     - Requires ChartDirector Ver 5.0 or above
#
# You may use and modify the code in this file in your application, provided the code and
# its modifications are used only in conjunction with ChartDirector. Usage of this software
# is subjected to the terms and condition of the ChartDirector license.
#/////////////////////////////////////////////////////////////////////////////////////////////////

#/ <summary>
#/ Represents a Financial Chart
#/ </summary>
class ChartDirector::FinanceChart < ChartDirector::MultiChart

    def initMembers()
        @m_totalWidth = 0
        @m_totalHeight = 0
        @m_antiAlias = true
        @m_logScale = false
        @m_axisOnRight = true

        @m_leftMargin = 40
        @m_rightMargin = 40
        @m_topMargin = 30
        @m_bottomMargin = 35

        @m_plotAreaBgColor = 0xffffff
        @m_plotAreaBorder = 0x888888
        @m_plotAreaGap = 2

        @m_majorHGridColor = 0xdddddd
        @m_minorHGridColor = 0xdddddd
        @m_majorVGridColor = 0xdddddd
        @m_minorVGridColor = 0xdddddd

        @m_legendFont = "normal"
        @m_legendFontSize = 8
        @m_legendFontColor = ChartDirector::TextColor
        @m_legendBgColor = 0x80cccccc

        @m_yAxisFont = "normal"
        @m_yAxisFontSize = 8
        @m_yAxisFontColor = ChartDirector::TextColor
        @m_yAxisMargin = 14

        @m_xAxisFont = "normal"
        @m_xAxisFontSize = 8
        @m_xAxisFontColor = ChartDirector::TextColor
        @m_xAxisFontAngle = 0

        @m_timeStamps = nil
        @m_highData = nil
        @m_lowData = nil
        @m_openData = nil
        @m_closeData = nil
        @m_volData = nil
        @m_volUnit = ""
        @m_extraPoints = 0

        @m_yearFormat = "{value|yyyy}"
        @m_firstMonthFormat = "<*font=bold*>{value|mmm yy}"
        @m_otherMonthFormat = "{value|mmm}"
        @m_firstDayFormat = "<*font=bold*>{value|d mmm}"
        @m_otherDayFormat = "{value|d}"
        @m_firstHourFormat = "<*font=bold*>{value|d mmm\nh:nna}"
        @m_otherHourFormat = "{value|h:nna}"
        @m_timeLabelSpacing = 50

        @m_generalFormat = "P3"

        @m_toolTipMonthFormat = "[{xLabel|mmm yyyy}]"
        @m_toolTipDayFormat = "[{xLabel|mmm d, yyyy}]"
        @m_toolTipHourFormat = "[{xLabel|mmm d, yyyy hh:nn:ss}]"

        @m_mainChart = nil
        @m_currentChart = nil
    end

    #/ <summary>
    #/ Create a FinanceChart with a given width. The height will be automatically determined
    #/ as the chart is built.
    #/ </summary>
    #/ <param name="width">Width of the chart in pixels</param>
    def initialize(width)
        super(width, 1)
        initMembers()
        @m_totalWidth = width
    end

    #/ <summary>
    #/ Enable/Disable anti-alias. Enabling anti-alias makes the line smoother. Disabling
    #/ anti-alias make the chart file size smaller, and so can be downloaded faster
    #/ through the Internet. The default is to enable anti-alias.
    #/ </summary>
    #/ <param name="antiAlias">True to enable anti-alias. False to disable anti-alias.</param>
    def enableAntiAlias(antiAlias)
        @m_antiAlias = antiAlias
    end

    #/ <summary>
    #/ Set the margins around the plot area.
    #/ </summary>
    #/ <param name="m_leftMargin">The distance between the plot area and the chart left edge.</param>
    #/ <param name="m_topMargin">The distance between the plot area and the chart top edge.</param>
    #/ <param name="m_rightMargin">The distance between the plot area and the chart right edge.</param>
    #/ <param name="m_bottomMargin">The distance between the plot area and the chart bottom edge.</param>
    def setMargins(leftMargin, topMargin, rightMargin, bottomMargin)
        @m_leftMargin = leftMargin
        @m_rightMargin = rightMargin
        @m_topMargin = topMargin
        @m_bottomMargin = bottomMargin
    end

    #/ <summary>
    #/ Add a text title above the plot area. You may add multiple title above the plot area by
    #/ calling this method multiple times.
    #/ </summary>
    #/ <param name="alignment">The alignment with respect to the region that is on top of the
    #/ plot area.</param>
    #/ <param name="text">The text to add.</param>
    #/ <returns>The TextBox object representing the text box above the plot area.</returns>
    def addPlotAreaTitle(alignment, text)
        ret = addText(@m_leftMargin, 0, text, "bold", 10, ChartDirector::TextColor, alignment)
        ret.setSize(@m_totalWidth - @m_leftMargin - @m_rightMargin + 1, @m_topMargin - 1)
        ret.setMargin(0)
        return ret
    end

    #/ <summary>
    #/ Set the plot area style. The default is to use pale yellow 0xfffff0 as the background,
    #/ and light grey 0xdddddd as the grid lines.
    #/ </summary>
    #/ <param name="bgColor">The plot area background color.</param>
    #/ <param name="majorHGridColor">Major horizontal grid color.</param>
    #/ <param name="majorVGridColor">Major vertical grid color.</param>
    #/ <param name="minorHGridColor">Minor horizontal grid color. In current version, minor
    #/ horizontal grid is not used.</param>
    #/ <param name="minorVGridColor">Minor vertical grid color.</param>
    def setPlotAreaStyle(bgColor, majorHGridColor, majorVGridColor, minorHGridColor, minorVGridColor
        )
        @m_plotAreaBgColor = bgColor
        @m_majorHGridColor = majorHGridColor
        @m_majorVGridColor = majorVGridColor
        @m_minorHGridColor = minorHGridColor
        @m_minorVGridColor = minorVGridColor
    end

    #/ <summary>
    #/ Set the plot area border style. The default is grey color (888888), with a gap
    #/ of 2 pixels between charts.
    #/ </summary>
    #/ <param name="borderColor">The color of the border.</param>
    #/ <param name="borderGap">The gap between two charts.</param>
    def setPlotAreaBorder(borderColor, borderGap)
        @m_plotAreaBorder = borderColor
        @m_plotAreaGap = borderGap
    end

    #/ <summary>
    #/ Set legend style. The default is Arial 8 pt black color, with light grey background.
    #/ </summary>
    #/ <param name="font">The font of the legend text.</param>
    #/ <param name="fontSize">The font size of the legend text in points.</param>
    #/ <param name="fontColor">The color of the legend text.</param>
    #/ <param name="bgColor">The background color of the legend box.</param>
    def setLegendStyle(font, fontSize, fontColor, bgColor)
        @m_legendFont = font
        @m_legendFontSize = fontSize
        @m_legendFontColor = fontColor
        @m_legendBgColor = bgColor
    end

    #/ <summary>
    #/ Set x-axis label style. The default is Arial 8 pt black color no rotation.
    #/ </summary>
    #/ <param name="font">The font of the axis labels.</param>
    #/ <param name="fontSize">The font size of the axis labels in points.</param>
    #/ <param name="fontColor">The color of the axis labels.</param>
    #/ <param name="fontAngle">The rotation of the axis labels.</param>
    def setXAxisStyle(font, fontSize, fontColor, fontAngle)
        @m_xAxisFont = font
        @m_xAxisFontSize = fontSize
        @m_xAxisFontColor = fontColor
        @m_xAxisFontAngle = fontAngle
    end

    #/ <summary>
    #/ Set y-axis label style. The default is Arial 8 pt black color, with 13 pixels margin.
    #/ </summary>
    #/ <param name="font">The font of the axis labels.</param>
    #/ <param name="fontSize">The font size of the axis labels in points.</param>
    #/ <param name="fontColor">The color of the axis labels.</param>
    #/ <param name="axisMargin">The margin at the top of the y-axis in pixels (to leave
    #/ space for the legend box).</param>
    def setYAxisStyle(font, fontSize, fontColor, axisMargin)
        @m_yAxisFont = font
        @m_yAxisFontSize = fontSize
        @m_yAxisFontColor = fontColor
        @m_yAxisMargin = axisMargin
    end

    #/ <summary>
    #/ Set whether the main y-axis is on right of left side of the plot area. The default is
    #/ on right.
    #/ </summary>
    #/ <param name="b">True if the y-axis is on right. False if the y-axis is on left.</param>
    def setAxisOnRight(b)
        @m_axisOnRight = b
    end

    #/ <summary>
    #/ Determines if log scale should be used for the main chart. The default is linear scale.
    #/ </summary>
    #/ <param name="b">True for using log scale. False for using linear scale.</param>
    def setLogScale(b)
        @m_logScale = b
        if @m_mainChart != nil
            if @m_logScale
                @m_mainChart.yAxis().setLogScale()
            else
                @m_mainChart.yAxis().setLinearScale()
            end
        end
    end

    #/ <summary>
    #/ Set the date/time formats to use for the x-axis labels under various cases.
    #/ </summary>
    #/ <param name="yearFormat">The format for displaying labels on an axis with yearly ticks. The
    #/ default is "yyyy".</param>
    #/ <param name="firstMonthFormat">The format for displaying labels on an axis with monthly ticks.
    #/ This parameter applies to the first available month of a year (usually January) only, so it can
    #/ be formatted differently from the other labels.</param>
    #/ <param name="otherMonthFormat">The format for displaying labels on an axis with monthly ticks.
    #/ This parameter applies to months other than the first available month of a year.</param>
    #/ <param name="firstDayFormat">The format for displaying labels on an axis with daily ticks.
    #/ This parameter applies to the first available day of a month only, so it can be formatted
    #/ differently from the other labels.</param>
    #/ <param name="otherDayFormat">The format for displaying labels on an axis with daily ticks.
    #/ This parameter applies to days other than the first available day of a month.</param>
    #/ <param name="firstHourFormat">The format for displaying labels on an axis with hourly
    #/ resolution. This parameter applies to the first tick of a day only, so it can be formatted
    #/ differently from the other labels.</param>
    #/ <param name="otherHourFormat">The format for displaying labels on an axis with hourly.
    #/ resolution. This parameter applies to ticks at hourly boundaries, except the first tick
    #/ of a day.</param>
    def setDateLabelFormat(yearFormat, firstMonthFormat, otherMonthFormat, firstDayFormat,
        otherDayFormat, firstHourFormat, otherHourFormat)
        if yearFormat != nil
            @m_yearFormat = yearFormat
        end
        if firstMonthFormat != nil
            @m_firstMonthFormat = firstMonthFormat
        end
        if otherMonthFormat != nil
            @m_otherMonthFormat = otherMonthFormat
        end
        if firstDayFormat != nil
            @m_firstDayFormat = firstDayFormat
        end
        if otherDayFormat != nil
            @m_otherDayFormat = otherDayFormat
        end
        if firstHourFormat != nil
            @m_firstHourFormat = firstHourFormat
        end
        if otherHourFormat != nil
            @m_otherHourFormat = otherHourFormat
        end
    end

    #/ <summary>
    #/ Set the minimum label spacing between two labels on the time axis
    #/ </summary>
    #/ <param name="labelSpacing">The minimum label spacing in pixels.</param>
    def setDateLabelSpacing(labelSpacing)
        if labelSpacing > 0
            @m_timeLabelSpacing = labelSpacing
        else
             @m_timeLabelSpacing = 0
        end
    end

    #/ <summary>
    #/ Set the tool tip formats for display date/time
    #/ </summary>
    #/ <param name="monthFormat">The tool tip format to use if the data point spacing is one
    #/ or more months (more than 30 days).</param>
    #/ <param name="dayFormat">The tool tip format to use if the data point spacing is 1 day
    #/ to less than 30 days.</param>
    #/ <param name="hourFormat">The tool tip format to use if the data point spacing is less
    #/ than 1 day.</param>
    def setToolTipDateFormat(monthFormat, dayFormat, hourFormat)
        if monthFormat != nil
            @m_toolTipMonthFormat = monthFormat
        end
        if dayFormat != nil
            @m_toolTipDayFormat = dayFormat
        end
        if hourFormat != nil
            @m_toolTipHourFormat = hourFormat
        end
    end

    #/ <summary>
    #/ Get the tool tip format for display date/time
    #/ </summary>
    #/ <returns>The tool tip format string.</returns>
    def getToolTipDateFormat()
        if @m_timeStamps == nil
            return @m_toolTipHourFormat
        end
        if @m_timeStamps.length <= @m_extraPoints
            return @m_toolTipHourFormat
        end
        resolution = (@m_timeStamps[@m_timeStamps.length - 1] - @m_timeStamps[0]) / (
            @m_timeStamps.length)
        if resolution >= 30 * 86400
            return @m_toolTipMonthFormat
        elsif resolution >= 86400
            return @m_toolTipDayFormat
        else
            return @m_toolTipHourFormat
        end
    end

    #/ <summary>
    #/ Set the number format for use in displaying values in legend keys and tool tips.
    #/ </summary>
    #/ <param name="formatString">The default number format.</param>
    def setNumberLabelFormat(formatString)
        if formatString != nil
            @m_generalFormat = formatString
        end
    end

    #/ <summary>
    #/ A utility function to compute triangular moving averages
    #/ </summary>
    #/ <param name="data">An array of numbers as input.</param>
    #/ <param name="period">The moving average period.</param>
    #/ <returns>An array representing the triangular moving average of the input array.</returns>
    def computeTriMovingAvg(data, period)
        p = period / 2 + 1
        return ChartDirector::ArrayMath.new(data).movAvg(p).movAvg(p).result()
    end

    #/ <summary>
    #/ A utility function to compute weighted moving averages
    #/ </summary>
    #/ <param name="data">An array of numbers as input.</param>
    #/ <param name="period">The moving average period.</param>
    #/ <returns>An array representing the weighted moving average of the input array.</returns>
    def computeWeightedMovingAvg(data, period)
        acc = ChartDirector::ArrayMath.new(data)
        2.upto(period) do |i|
            acc.add(ChartDirector::ArrayMath.new(data).movAvg(i).mul(i).result())
        end
        return acc.div((1 + period) * period / 2).result()
    end

    #/ <summary>
    #/ A utility function to obtain the first visible closing price.
    #/ </summary>
    #/ <returns>The first closing price.
    #/ are cd.NoValue.</returns>
    def firstCloseValue()
        @m_extraPoints.upto(@m_closeData.length - 1) do |i|
            if (@m_closeData[i] != ChartDirector::NoValue) && (@m_closeData[i] != 0)
                return @m_closeData[i]
            end
        end
        return ChartDirector::NoValue
    end

    #/ <summary>
    #/ A utility function to obtain the last valid position (that is, position not
    #/ containing cd.NoValue) of a data series.
    #/ </summary>
    #/ <param name="data">An array of numbers as input.</param>
    #/ <returns>The last valid position in the input array, or -1 if all positions
    #/ are cd.NoValue.</returns>
    def lastIndex(data)
        i = data.length - 1
        while i >= 0
            if data[i] != ChartDirector::NoValue
                break
            end
            i = i - 1
        end
        return i
    end

    #/ <summary>
    #/ Set the data used in the chart. If some of the data are not available, some artifical
    #/ values should be used. For example, if the high and low values are not available, you
    #/ may use closeData as highData and lowData.
    #/ </summary>
    #/ <param name="timeStamps">An array of dates/times for the time intervals.</param>
    #/ <param name="highData">The high values in the time intervals.</param>
    #/ <param name="lowData">The low values in the time intervals.</param>
    #/ <param name="openData">The open values in the time intervals.</param>
    #/ <param name="closeData">The close values in the time intervals.</param>
    #/ <param name="volData">The volume values in the time intervals.</param>
    #/ <param name="extraPoints">The number of leading time intervals that are not
    #/ displayed in the chart. These intervals are typically used for computing
    #/ indicators that require extra leading data, such as moving averages.</param>
    def setData(timeStamps, highData, lowData, openData, closeData, volData, extraPoints)
        @m_timeStamps = timeStamps
        @m_highData = highData
        @m_lowData = lowData
        @m_openData = openData
        @m_closeData = closeData
        if extraPoints > 0
            @m_extraPoints = extraPoints
        else
            @m_extraPoints = 0
        end

        #///////////////////////////////////////////////////////////////////////
        # Auto-detect volume units
        #///////////////////////////////////////////////////////////////////////
        maxVol = ChartDirector::ArrayMath.new(volData).max()
        units = ["", "K", "M", "B"]
        unitIndex = units.length - 1
        while (unitIndex > 0) && (maxVol < 1000**unitIndex)
            unitIndex = unitIndex - 1
        end

        @m_volData = ChartDirector::ArrayMath.new(volData).div(1000**unitIndex).result()
        @m_volUnit = units[unitIndex]
    end

    #////////////////////////////////////////////////////////////////////////////
    # Format x-axis labels
    #////////////////////////////////////////////////////////////////////////////
    def setXLabels(a)
        a.setLabels2(@m_timeStamps)
        if @m_extraPoints < @m_timeStamps.length
            tickStep = ((@m_timeStamps.length - @m_extraPoints) * @m_timeLabelSpacing / (
                @m_totalWidth - @m_leftMargin - @m_rightMargin)).to_i + 1
            timeRangeInSeconds = @m_timeStamps[@m_timeStamps.length - 1] - @m_timeStamps[
                @m_extraPoints]
            secondsBetweenTicks = timeRangeInSeconds / (
                @m_totalWidth - @m_leftMargin - @m_rightMargin) * @m_timeLabelSpacing

            if secondsBetweenTicks * (@m_timeStamps.length - @m_extraPoints) <= timeRangeInSeconds
                tickStep = 1
                if @m_timeStamps.length > 1
                    secondsBetweenTicks = @m_timeStamps[@m_timeStamps.length - 1] - @m_timeStamps[
                        @m_timeStamps.length - 2]
                else
                    secondsBetweenTicks = 86400
                end
            end

            if (secondsBetweenTicks > 360 * 86400) || ((secondsBetweenTicks > 90 * 86400) && (
                timeRangeInSeconds >= 720 * 86400))
                #yearly ticks
                a.setMultiFormat2(ChartDirector::StartOfYearFilter(), @m_yearFormat, tickStep)
            elsif (secondsBetweenTicks >= 30 * 86400) || ((secondsBetweenTicks > 7 * 86400) && (
                timeRangeInSeconds >= 60 * 86400))
                #monthly ticks
                monthBetweenTicks = (secondsBetweenTicks / 31 / 86400).to_i + 1
                a.setMultiFormat(ChartDirector::StartOfYearFilter(), @m_firstMonthFormat,
                    ChartDirector::StartOfMonthFilter(monthBetweenTicks), @m_otherMonthFormat)
                a.setMultiFormat2(ChartDirector::StartOfMonthFilter(), "-", 1, false)
            elsif (secondsBetweenTicks >= 86400) || ((secondsBetweenTicks > 6 * 3600) && (
                timeRangeInSeconds >= 86400))
                #daily ticks
                a.setMultiFormat(ChartDirector::StartOfMonthFilter(), @m_firstDayFormat,
                    ChartDirector::StartOfDayFilter(1, 0.5), @m_otherDayFormat, tickStep)
            else
                #hourly ticks
                a.setMultiFormat(ChartDirector::StartOfDayFilter(1, 0.5), @m_firstHourFormat,
                    ChartDirector::StartOfHourFilter(1, 0.5), @m_otherHourFormat, tickStep)
            end
        end
    end

    #////////////////////////////////////////////////////////////////////////////
    # Create tool tip format string for showing OHLC data
    #////////////////////////////////////////////////////////////////////////////
    def getHLOCToolTipFormat()
        return sprintf("title='%s Op:{open|%s}, Hi:{high|%s}, Lo:{low|%s}, Cl:{close|%s}'",
            getToolTipDateFormat(), @m_generalFormat, @m_generalFormat, @m_generalFormat,
            @m_generalFormat)
    end

    #/ <summary>
    #/ Add the main chart - the chart that shows the HLOC data.
    #/ </summary>
    #/ <param name="height">The height of the main chart in pixels.</param>
    #/ <returns>An XYChart object representing the main chart created.</returns>
    def addMainChart(height)
        @m_mainChart = addIndicator(height)
        setMainChart(@m_mainChart)
        @m_mainChart.yAxis().setMargin(2 * @m_yAxisMargin)
        if @m_logScale
            @m_mainChart.yAxis().setLogScale()
        else
            @m_mainChart.yAxis().setLinearScale()
        end
        return @m_mainChart
    end

    #/ <summary>
    #/ Add a candlestick layer to the main chart.
    #/ </summary>
    #/ <param name="upColor">The candle color for an up day.</param>
    #/ <param name="downColor">The candle color for a down day.</param>
    #/ <returns>The CandleStickLayer created.</returns>
    def addCandleStick(upColor, downColor)
        addOHLCLabel(upColor, downColor, true)
        ret = @m_mainChart.addCandleStickLayer(@m_highData, @m_lowData, @m_openData, @m_closeData,
            upColor, downColor)
        ret.setHTMLImageMap("", "", getHLOCToolTipFormat())
        if @m_highData.length - @m_extraPoints > 60
            ret.setDataGap(0)
        end

        if @m_highData.length > @m_extraPoints
            expectedWidth = (@m_totalWidth - @m_leftMargin - @m_rightMargin) / (
                @m_highData.length - @m_extraPoints)
            if expectedWidth <= 5
                ret.setDataWidth(expectedWidth + 1 - expectedWidth % 2)
            end
        end

        return ret
    end

    #/ <summary>
    #/ Add a HLOC layer to the main chart.
    #/ </summary>
    #/ <param name="upColor">The color of the HLOC symbol for an up day.</param>
    #/ <param name="downColor">The color of the HLOC symbol for a down day.</param>
    #/ <returns>The HLOCLayer created.</returns>
    def addHLOC(upColor, downColor)
        addOHLCLabel(upColor, downColor, false)
        ret = @m_mainChart.addHLOCLayer(@m_highData, @m_lowData, @m_openData, @m_closeData)
        ret.setColorMethod(ChartDirector::HLOCUpDown, upColor, downColor)
        ret.setHTMLImageMap("", "", getHLOCToolTipFormat())
        ret.setDataGap(0)
        return ret
    end

    def addOHLCLabel(upColor, downColor, candleStickMode)
        i = lastIndex(@m_closeData)
        if i >= 0
            openValue = ChartDirector::NoValue
            closeValue = ChartDirector::NoValue
            highValue = ChartDirector::NoValue
            lowValue = ChartDirector::NoValue

            if i < @m_openData.length
                openValue = @m_openData[i]
            end
            if i < @m_closeData.length
                closeValue = @m_closeData[i]
            end
            if i < @m_highData.length
                highValue = @m_highData[i]
            end
            if i < @m_lowData.length
                lowValue = @m_lowData[i]
            end

            openLabel = ""
            closeLabel = ""
            highLabel = ""
            lowLabel = ""
            delim = ""
            if openValue != ChartDirector::NoValue
                openLabel = sprintf("Op:%s", formatValue(openValue, @m_generalFormat))
                delim = ", "
            end
            if highValue != ChartDirector::NoValue
                highLabel = sprintf("%sHi:%s", delim, formatValue(highValue, @m_generalFormat))
                delim = ", "
            end
            if lowValue != ChartDirector::NoValue
                lowLabel = sprintf("%sLo:%s", delim, formatValue(lowValue, @m_generalFormat))
                delim = ", "
            end
            if closeValue != ChartDirector::NoValue
                closeLabel = sprintf("%sCl:%s", delim, formatValue(closeValue, @m_generalFormat))
                delim = ", "
            end
            label = sprintf("%s%s%s%s", openLabel, highLabel, lowLabel, closeLabel)

            useUpColor = (closeValue >= openValue)
            if candleStickMode != true
                closeChanges = ChartDirector::ArrayMath.new(@m_closeData).delta().result()
                lastChangeIndex = lastIndex(closeChanges)
                useUpColor = (lastChangeIndex < 0)
                if useUpColor != true
                    useUpColor = (closeChanges[lastChangeIndex] >= 0)
                end
            end

            udcolor = downColor
            if useUpColor
                udcolor = upColor
            end
            @m_mainChart.getLegend().addKey(label, udcolor)
        end
    end

    #/ <summary>
    #/ Add a closing price line on the main chart.
    #/ </summary>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addCloseLine(color)
        return addLineIndicator2(@m_mainChart, @m_closeData, color, "Closing Price")
    end

    #/ <summary>
    #/ Add a weight close line on the main chart.
    #/ </summary>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addWeightedClose(color)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(@m_highData).add(
            @m_lowData).add(@m_closeData).add(@m_closeData).div(4).result(), color, "Weighted Close"
            )
    end

    #/ <summary>
    #/ Add a typical price line on the main chart.
    #/ </summary>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addTypicalPrice(color)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(@m_highData).add(
            @m_lowData).add(@m_closeData).div(3).result(), color, "Typical Price")
    end

    #/ <summary>
    #/ Add a median price line on the main chart.
    #/ </summary>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addMedianPrice(color)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(@m_highData).add(
            @m_lowData).div(2).result(), color, "Median Price")
    end

    #/ <summary>
    #/ Add a simple moving average line on the main chart.
    #/ </summary>
    #/ <param name="period">The moving average period</param>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addSimpleMovingAvg(period, color)
        label = sprintf("SMA (%s)", period)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(@m_closeData).movAvg(
            period).result(), color, label)
    end

    #/ <summary>
    #/ Add an exponential moving average line on the main chart.
    #/ </summary>
    #/ <param name="period">The moving average period</param>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addExpMovingAvg(period, color)
        label = sprintf("EMA (%s)", period)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(@m_closeData).expAvg(
            2.0 / (period + 1)).result(), color, label)
    end

    #/ <summary>
    #/ Add a triangular moving average line on the main chart.
    #/ </summary>
    #/ <param name="period">The moving average period</param>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addTriMovingAvg(period, color)
        label = sprintf("TMA (%s)", period)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(computeTriMovingAvg(
            @m_closeData, period)).result(), color, label)
    end

    #/ <summary>
    #/ Add a weighted moving average line on the main chart.
    #/ </summary>
    #/ <param name="period">The moving average period</param>
    #/ <param name="color">The color of the line.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addWeightedMovingAvg(period, color)
        label = sprintf("WMA (%s)", period)
        return addLineIndicator2(@m_mainChart, ChartDirector::ArrayMath.new(
            computeWeightedMovingAvg(@m_closeData, period)).result(), color, label)
    end

    #/ <summary>
    #/ Add a parabolic SAR indicator to the main chart.
    #/ </summary>
    #/ <param name="accInitial">Initial acceleration factor</param>
    #/ <param name="accIncrement">Acceleration factor increment</param>
    #/ <param name="accMaximum">Maximum acceleration factor</param>
    #/ <param name="symbolType">The symbol used to plot the parabolic SAR</param>
    #/ <param name="symbolSize">The symbol size in pixels</param>
    #/ <param name="fillColor">The fill color of the symbol</param>
    #/ <param name="edgeColor">The edge color of the symbol</param>
    #/ <returns>The LineLayer object representing the layer created.</returns>
    def addParabolicSAR(accInitial, accIncrement, accMaximum, symbolType, symbolSize, fillColor,
        edgeColor)
        isLong = true
        acc = accInitial
        extremePoint = 0
        psar = Array.new(@m_lowData.length)

        i_1 = -1
        i_2 = -1

        0.upto(@m_lowData.length - 1) do |i|
            psar[i] = ChartDirector::NoValue
            if (@m_lowData[i] != ChartDirector::NoValue) && (@m_highData[i
                ] != ChartDirector::NoValue)
                if (i_1 >= 0) && (i_2 < 0)
                    if @m_lowData[i_1] <= @m_lowData[i]
                        psar[i] = @m_lowData[i_1]
                        isLong = true
                        if @m_highData[i_1] > @m_highData[i]
                            extremePoint = @m_highData[i_1]
                        else
                            extremePoint = @m_highData[i]
                        end
                    else
                        extremePoint = @m_lowData[i]
                        isLong = false
                        if @m_highData[i_1] > @m_highData[i]
                            psar[i] = @m_highData[i_1]
                        else
                            psar[i] = @m_highData[i]
                        end
                    end
                elsif (i_1 >= 0) && (i_2 >= 0)
                    if acc > accMaximum
                        acc = accMaximum
                    end

                    psar[i] = psar[i_1] + acc * (extremePoint - psar[i_1])

                    if isLong
                        if @m_lowData[i] < psar[i]
                            isLong = false
                            psar[i] = extremePoint
                            extremePoint = @m_lowData[i]
                            acc = accInitial
                        else
                            if @m_highData[i] > extremePoint
                                extremePoint = @m_highData[i]
                                acc = acc + accIncrement
                            end

                            if @m_lowData[i_1] < psar[i]
                                psar[i] = @m_lowData[i_1]
                            end
                            if @m_lowData[i_2] < psar[i]
                                psar[i] = @m_lowData[i_2]
                            end
                        end
                    else
                        if @m_highData[i] > psar[i]
                            isLong = true
                            psar[i] = extremePoint
                            extremePoint = @m_highData[i]
                            acc = accInitial
                        else
                            if @m_lowData[i] < extremePoint
                                extremePoint = @m_lowData[i]
                                acc = acc + accIncrement
                            end

                            if @m_highData[i_1] > psar[i]
                                psar[i] = @m_highData[i_1]
                            end
                            if @m_highData[i_2] > psar[i]
                                psar[i] = @m_highData[i_2]
                            end
                        end
                    end
                end

                i_2 = i_1
                i_1 = i
            end
        end

        ret = addLineIndicator2(@m_mainChart, psar, fillColor, "Parabolic SAR")
        ret.setLineWidth(0)
        ret.addDataSet(psar).setDataSymbol(symbolType, symbolSize, fillColor, edgeColor)
        return ret
    end

    #/ <summary>
    #/ Add a comparison line to the main price chart.
    #/ </summary>
    #/ <param name="data">The data series to compare to</param>
    #/ <param name="color">The color of the comparison line</param>
    #/ <param name="name">The name of the comparison line</param>
    #/ <returns>The LineLayer object representing the line layer created.</returns>
    def addComparison(data, color, name)
        firstIndex = @m_extraPoints
        while (firstIndex < data.length) && (firstIndex < @m_closeData.length)
            if (data[firstIndex] != ChartDirector::NoValue) && (@m_closeData[firstIndex
                ] != ChartDirector::NoValue) && (data[firstIndex] != 0) && (@m_closeData[firstIndex
                ] != 0)
                break
            end
            firstIndex = firstIndex + 1
        end
        if (firstIndex >= data.length) || (firstIndex >= @m_closeData.length)
            return nil
        end

        scaleFactor = @m_closeData[firstIndex] / data[firstIndex]
        layer = @m_mainChart.addLineLayer(ChartDirector::ArrayMath.new(data).mul(scaleFactor
            ).result(), ChartDirector::Transparent)
        layer.setHTMLImageMap("{disable}")

        a = @m_mainChart.addAxis(ChartDirector::Right, 0)
        a.setColors(ChartDirector::Transparent, ChartDirector::Transparent)
        a.syncAxis(@m_mainChart.yAxis(), 1 / scaleFactor, 0)

        ret = addLineIndicator2(@m_mainChart, data, color, name)
        ret.setUseYAxis(a)
        return ret
    end

    #/ <summary>
    #/ Display percentage axis scale
    #/ </summary>
    #/ <returns>The Axis object representing the percentage axis.</returns>
    def setPercentageAxis()
        firstClose = firstCloseValue()
        if firstClose == ChartDirector::NoValue
            return nil
        end

        axisAlign = ChartDirector::Left
        if @m_axisOnRight
            axisAlign = ChartDirector::Right
        end

        ret = @m_mainChart.addAxis(axisAlign, 0)
        configureYAxis(ret, 300)
        ret.syncAxis(@m_mainChart.yAxis(), 100 / firstClose)
        ret.setRounding(false, false)
        ret.setLabelFormat("{={value}-100|@}%")
        @m_mainChart.yAxis().setColors(ChartDirector::Transparent, ChartDirector::Transparent)
        @m_mainChart.getPlotArea().setGridAxis(nil, ret)
        return ret
    end

    #/ <summary>
    #/ Add a generic band to the main finance chart. This method is used internally by other methods to add
    #/ various bands (eg. Bollinger band, Donchian channels, etc).
    #/ </summary>
    #/ <param name="upperLine">The data series for the upper band line.</param>
    #/ <param name="lowerLine">The data series for the lower band line.</param>
    #/ <param name="lineColor">The color of the upper and lower band line.</param>
    #/ <param name="fillColor">The color to fill the region between the upper and lower band lines.</param>
    #/ <param name="name">The name of the band.</param>
    #/ <returns>An InterLineLayer object representing the filled region.</returns>
    def addBand(upperLine, lowerLine, lineColor, fillColor, name)
        i = upperLine.length - 1
        if i >= lowerLine.length
            i = lowerLine.length - 1
        end

        while i >= 0
            if (upperLine[i] != ChartDirector::NoValue) && (lowerLine[i] != ChartDirector::NoValue)
                name = sprintf("%s: %s - %s", name, formatValue(lowerLine[i], @m_generalFormat),
                    formatValue(upperLine[i], @m_generalFormat))
                break
            end
            i = i - 1
        end

        uLayer = @m_mainChart.addLineLayer(upperLine, lineColor, name)
        lLayer = @m_mainChart.addLineLayer(lowerLine, lineColor)
        return @m_mainChart.addInterLineLayer(uLayer.getLine(), lLayer.getLine(), fillColor)
    end

    #/ <summary>
    #/ Add a Bollinger band on the main chart.
    #/ </summary>
    #/ <param name="period">The period to compute the band.</param>
    #/ <param name="bandWidth">The half-width of the band in terms multiples of standard deviation. Typically 2 is used.</param>
    #/ <param name="lineColor">The color of the lines defining the upper and lower limits.</param>
    #/ <param name="fillColor">The color to fill the regional within the band.</param>
    #/ <returns>The InterLineLayer object representing the band created.</returns>
    def addBollingerBand(period, bandWidth, lineColor, fillColor)
        #Bollinger Band is moving avg +/- (width * moving std deviation)
        stdDev = ChartDirector::ArrayMath.new(@m_closeData).movStdDev(period).mul(bandWidth).result(
            )
        movAvg = ChartDirector::ArrayMath.new(@m_closeData).movAvg(period).result()
        label = sprintf("Bollinger (%s, %s)", period, bandWidth)
        return addBand(ChartDirector::ArrayMath.new(movAvg).add(stdDev).result(),
            ChartDirector::ArrayMath.new(movAvg).sub(stdDev).selectGTZ(nil, 0).result(), lineColor,
            fillColor, label)
    end

    #/ <summary>
    #/ Add a Donchian channel on the main chart.
    #/ </summary>
    #/ <param name="period">The period to compute the band.</param>
    #/ <param name="lineColor">The color of the lines defining the upper and lower limits.</param>
    #/ <param name="fillColor">The color to fill the regional within the band.</param>
    #/ <returns>The InterLineLayer object representing the band created.</returns>
    def addDonchianChannel(period, lineColor, fillColor)
        #Donchian Channel is the zone between the moving max and moving min
        label = sprintf("Donchian (%s)", period)
        return addBand(ChartDirector::ArrayMath.new(@m_highData).movMax(period).result(),
            ChartDirector::ArrayMath.new(@m_lowData).movMin(period).result(), lineColor, fillColor,
            label)
    end

    #/ <summary>
    #/ Add a price envelop on the main chart. The price envelop is a defined as a ratio around a
    #/ moving average. For example, a ratio of 0.2 means 20% above and below the moving average.
    #/ </summary>
    #/ <param name="period">The period for the moving average.</param>
    #/ <param name="range">The ratio above and below the moving average.</param>
    #/ <param name="lineColor">The color of the lines defining the upper and lower limits.</param>
    #/ <param name="fillColor">The color to fill the regional within the band.</param>
    #/ <returns>The InterLineLayer object representing the band created.</returns>
    def addEnvelop(period, range, lineColor, fillColor)
        #Envelop is moving avg +/- percentage
        movAvg = ChartDirector::ArrayMath.new(@m_closeData).movAvg(period).result()
        label = sprintf("Envelop (SMA %s +/- %s%%)", period, (range * 100).to_i)
        return addBand(ChartDirector::ArrayMath.new(movAvg).mul(1 + range).result(),
            ChartDirector::ArrayMath.new(movAvg).mul(1 - range).result(), lineColor, fillColor,
            label)
    end

    #/ <summary>
    #/ Add a volume bar chart layer on the main chart.
    #/ </summary>
    #/ <param name="height">The height of the bar chart layer in pixels.</param>
    #/ <param name="upColor">The color to used on an 'up' day. An 'up' day is a day where
    #/ the closing price is higher than that of the previous day.</param>
    #/ <param name="downColor">The color to used on a 'down' day. A 'down' day is a day
    #/ where the closing price is lower than that of the previous day.</param>
    #/ <param name="flatColor">The color to used on a 'flat' day. A 'flat' day is a day
    #/ where the closing price is the same as that of the previous day.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addVolBars(height, upColor, downColor, flatColor)
        return addVolBars2(@m_mainChart, height, upColor, downColor, flatColor)
    end

    def addVolBars2(c, height, upColor, downColor, flatColor)
        barLayer = c.addBarLayer2(ChartDirector::Overlay)
        barLayer.setBorderColor(ChartDirector::Transparent)

        if c == @m_mainChart
            configureYAxis(c.yAxis2(), height)
            topMargin = c.getDrawArea().getHeight(
                ) - @m_topMargin - @m_bottomMargin - height + @m_yAxisMargin
            if topMargin < 0
                topMargin = 0
            end
            c.yAxis2().setTopMargin(topMargin)
            barLayer.setUseYAxis2()
        end

        a = c.yAxis2()
        if c != @m_mainChart
            a = c.yAxis()
        end
        if ChartDirector::ArrayMath.new(@m_volData).max() < 10
            a.setLabelFormat(sprintf("{value|1}%s", @m_volUnit))
        else
            a.setLabelFormat(sprintf("{value}%s", @m_volUnit))
        end

        closeChange = ChartDirector::ArrayMath.new(@m_closeData).delta().result()
        i = lastIndex(@m_volData)
        label = "Vol"
        if i >= 0
            label = sprintf("%s: %s%s", label, formatValue(@m_volData[i], @m_generalFormat),
                @m_volUnit)
            closeChange[0] = 0
        end

        upDS = barLayer.addDataSet(ChartDirector::ArrayMath.new(@m_volData).selectGTZ(closeChange
            ).result(), upColor)
        dnDS = barLayer.addDataSet(ChartDirector::ArrayMath.new(@m_volData).selectLTZ(closeChange
            ).result(), downColor)
        flatDS = barLayer.addDataSet(ChartDirector::ArrayMath.new(@m_volData).selectEQZ(closeChange
            ).result(), flatColor)

        if (i < 0) || (closeChange[i] == 0) || (closeChange[i] == ChartDirector::NoValue)
            flatDS.setDataName(label)
        elsif closeChange[i] > 0
            upDS.setDataName(label)
        else
            dnDS.setDataName(label)
        end

        return barLayer
    end

    #/ <summary>
    #/ Add a blank indicator chart to the finance chart. Used internally to add other indicators.
    #/ Override to change the default formatting (eg. axis fonts, etc.) of the various indicators.
    #/ </summary>
    #/ <param name="height">The height of the chart in pixels.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addIndicator(height)
        #create a new chart object
        ret = ChartDirector::XYChart.new(@m_totalWidth, height + @m_topMargin + @m_bottomMargin,
            ChartDirector::Transparent)
        ret.setTrimData(@m_extraPoints)

        if @m_currentChart != nil
            #if there is a chart before the newly created chart, disable its x-axis, and copy
            #its x-axis labels to the new chart
            @m_currentChart.xAxis().setColors(ChartDirector::Transparent, ChartDirector::Transparent
                )
            ret.xAxis().copyAxis(@m_currentChart.xAxis())

            #add chart to MultiChart and update the total height
            addChart(0, @m_totalHeight + @m_plotAreaGap, ret)
            @m_totalHeight = @m_totalHeight + height + 1 + @m_plotAreaGap
        else
            #no existing chart - create the x-axis labels from scratch
            setXLabels(ret.xAxis())

            #add chart to MultiChart and update the total height
            addChart(0, @m_totalHeight, ret)
            @m_totalHeight = @m_totalHeight + height + 1
        end

        #the newly created chart becomes the current chart
        @m_currentChart = ret

        #update the size
        setSize(@m_totalWidth, @m_totalHeight + @m_topMargin + @m_bottomMargin)

        #configure the plot area
        ret.setPlotArea(@m_leftMargin, @m_topMargin, @m_totalWidth - @m_leftMargin - @m_rightMargin,
            height, @m_plotAreaBgColor, -1, @m_plotAreaBorder).setGridColor(@m_majorHGridColor,
            @m_majorVGridColor, @m_minorHGridColor, @m_minorVGridColor)
        ret.setAntiAlias(@m_antiAlias)

        #configure legend box
        box = ret.addLegend(@m_leftMargin, @m_topMargin, false, @m_legendFont, @m_legendFontSize)
        box.setFontColor(@m_legendFontColor)
        box.setBackground(@m_legendBgColor)
        box.setMargin2(5, 0, 2, 1)
        box.setSize(@m_totalWidth - @m_leftMargin - @m_rightMargin + 1, 0)

        #configure x-axis
        a = ret.xAxis()
        a.setIndent(true)
        a.setTickLength(2, 0)
        a.setColors(ChartDirector::Transparent, @m_xAxisFontColor, @m_xAxisFontColor,
            @m_xAxisFontColor)
        a.setLabelStyle(@m_xAxisFont, @m_xAxisFontSize, @m_xAxisFontColor, @m_xAxisFontAngle)

        #configure y-axis
        ret.setYAxisOnRight(@m_axisOnRight)
        configureYAxis(ret.yAxis(), height)

        return ret
    end

    def configureYAxis(a, height)
        a.setAutoScale(0, 0.05, 0)
        if height < 100
            a.setTickDensity(15)
        end
        a.setMargin(@m_yAxisMargin)
        a.setLabelStyle(@m_yAxisFont, @m_yAxisFontSize, @m_yAxisFontColor, 0)
        a.setTickLength(-4, -2)
        a.setColors(ChartDirector::Transparent, @m_yAxisFontColor, @m_yAxisFontColor,
            @m_yAxisFontColor)
    end

    #/ <summary>
    #/ Add a generic line indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="data">The data series of the indicator line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="name">The name of the indicator.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addLineIndicator(height, data, color, name)
        c = addIndicator(height)
        addLineIndicator2(c, data, color, name)
        return c
    end

    #/ <summary>
    #/ Add a line to an existing indicator chart.
    #/ </summary>
    #/ <param name="c">The indicator chart to add the line to.</param>
    #/ <param name="data">The data series of the indicator line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="name">The name of the indicator.</param>
    #/ <returns>The LineLayer object representing the line created.</returns>
    def addLineIndicator2(c, data, color, name)
        return c.addLineLayer(data, color, formatIndicatorLabel(name, data))
    end

    #/ <summary>
    #/ Add a generic bar indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="data">The data series of the indicator bars.</param>
    #/ <param name="color">The color of the indicator bars.</param>
    #/ <param name="name">The name of the indicator.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addBarIndicator(height, data, color, name)
        c = addIndicator(height)
        addBarIndicator2(c, data, color, name)
        return c
    end

    #/ <summary>
    #/ Add a bar layer to an existing indicator chart.
    #/ </summary>
    #/ <param name="c">The indicator chart to add the bar layer to.</param>
    #/ <param name="data">The data series of the indicator bars.</param>
    #/ <param name="color">The color of the indicator bars.</param>
    #/ <param name="name">The name of the indicator.</param>
    #/ <returns>The BarLayer object representing the bar layer created.</returns>
    def addBarIndicator2(c, data, color, name)
        layer = c.addBarLayer(data, color, formatIndicatorLabel(name, data))
        layer.setBorderColor(ChartDirector::Transparent)
        return layer
    end

    #/ <summary>
    #/ Add an upper/lower threshold range to an existing indicator chart.
    #/ </summary>
    #/ <param name="c">The indicator chart to add the threshold range to.</param>
    #/ <param name="layer">The line layer that the threshold range applies to.</param>
    #/ <param name="topRange">The upper threshold.</param>
    #/ <param name="topColor">The color to fill the region of the line that is above the
    #/ upper threshold.</param>
    #/ <param name="bottomRange">The lower threshold.</param>
    #/ <param name="bottomColor">The color to fill the region of the line that is below
    #/ the lower threshold.</param>
    def addThreshold(c, layer, topRange, topColor, bottomRange, bottomColor)
        topMark = c.yAxis().addMark(topRange, topColor, formatValue(topRange, @m_generalFormat))
        bottomMark = c.yAxis().addMark(bottomRange, bottomColor, formatValue(bottomRange,
            @m_generalFormat))

        c.addInterLineLayer(layer.getLine(), topMark.getLine(), topColor, ChartDirector::Transparent
            )
        c.addInterLineLayer(layer.getLine(), bottomMark.getLine(), ChartDirector::Transparent,
            bottomColor)
    end

    def formatIndicatorLabel(name, data)
        i = lastIndex(data)
        if name == nil
            return name
        end
        if (name == "") || (i < 0)
            return name
        end
        ret = sprintf("%s: %s", name, formatValue(data[i], @m_generalFormat))
        return ret
    end

    #/ <summary>
    #/ Add an Accumulation/Distribution indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addAccDist(height, color)
        #Close Location Value = ((C - L) - (H - C)) / (H - L)
        #Accumulation Distribution Line = Accumulation of CLV * volume
        range = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).result()
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).mul(2).sub(
            @m_lowData).sub(@m_highData).mul(@m_volData).financeDiv(range, 0).acc().result(), color,
            "Accumulation/Distribution")
    end

    def computeAroonUp(period)
        aroonUp = Array.new(@m_highData.length)
        0.upto(@m_highData.length - 1) do |i|
            highValue = @m_highData[i]
            if highValue == ChartDirector::NoValue
                aroonUp[i] = ChartDirector::NoValue
            else
                currentIndex = i
                highCount = period
                count = period

                while (count > 0) && (currentIndex >= count)
                    currentIndex = currentIndex - 1
                    currentValue = @m_highData[currentIndex]
                    if currentValue != ChartDirector::NoValue
                        count = count - 1
                        if currentValue > highValue
                            highValue = currentValue
                            highCount = count
                        end
                    end
                end

                if count > 0
                    aroonUp[i] = ChartDirector::NoValue
                else
                    aroonUp[i] = highCount * 100.0 / period
                end
            end
        end

        return aroonUp
    end

    def computeAroonDn(period)
        aroonDn = Array.new(@m_lowData.length)
        0.upto(@m_lowData.length - 1) do |i|
            lowValue = @m_lowData[i]
            if lowValue == ChartDirector::NoValue
                aroonDn[i] = ChartDirector::NoValue
            else
                currentIndex = i
                lowCount = period
                count = period

                while (count > 0) && (currentIndex >= count)
                    currentIndex = currentIndex - 1
                    currentValue = @m_lowData[currentIndex]
                    if currentValue != ChartDirector::NoValue
                        count = count - 1
                        if currentValue < lowValue
                            lowValue = currentValue
                            lowCount = count
                        end
                    end
                end

                if count > 0
                    aroonDn[i] = ChartDirector::NoValue
                else
                    aroonDn[i] = lowCount * 100.0 / period
                end
            end
        end

        return aroonDn
    end

    #/ <summary>
    #/ Add an Aroon Up/Down indicators chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicators.</param>
    #/ <param name="upColor">The color of the Aroon Up indicator line.</param>
    #/ <param name="downColor">The color of the Aroon Down indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addAroon(height, period, upColor, downColor)
        c = addIndicator(height)
        addLineIndicator2(c, computeAroonUp(period), upColor, "Aroon Up")
        addLineIndicator2(c, computeAroonDn(period), downColor, "Aroon Down")
        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add an Aroon Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addAroonOsc(height, period, color)
        label = sprintf("Aroon Oscillator (%s)", period)
        c = addLineIndicator(height, ChartDirector::ArrayMath.new(computeAroonUp(period)).sub(
            computeAroonDn(period)).result(), color, label)
        c.yAxis().setLinearScale(-100, 100)
        return c
    end

    def computeTrueRange()
        previousClose = ChartDirector::ArrayMath.new(@m_closeData).shift().result()
        ret = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).result()
        temp = 0

        0.upto(@m_highData.length - 1) do |i|
            if (ret[i] != ChartDirector::NoValue) && (previousClose[i] != ChartDirector::NoValue)
                temp = (@m_highData[i] - previousClose[i]).abs
                if temp > ret[i]
                    ret[i] = temp
                end
                temp = (previousClose[i] - @m_lowData[i]).abs
                if temp > ret[i]
                    ret[i] = temp
                end
            end
        end

        return ret
    end

    #/ <summary>
    #/ Add an Average Directional Index indicators chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="posColor">The color of the Positive Directional Index line.</param>
    #/ <param name="negColor">The color of the Negatuve Directional Index line.</param>
    #/ <param name="color">The color of the Average Directional Index line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addADX(height, period, posColor, negColor, color)
        #pos/neg directional movement
        pos = ChartDirector::ArrayMath.new(@m_highData).delta().selectGTZ()
        neg = ChartDirector::ArrayMath.new(@m_lowData).delta().mul(-1).selectGTZ()
        delta = ChartDirector::ArrayMath.new(pos.result()).sub(neg.result()).result()
        pos.selectGTZ(delta)
        neg.selectLTZ(delta)

        #pos/neg directional index
        tr = computeTrueRange()
        pos.financeDiv(tr, 0.25).mul(100).expAvg(2.0 / (period + 1))
        neg.financeDiv(tr, 0.25).mul(100).expAvg(2.0 / (period + 1))

        #directional movement index ??? what happen if division by zero???
        totalDM = ChartDirector::ArrayMath.new(pos.result()).add(neg.result()).result()
        dx = ChartDirector::ArrayMath.new(pos.result()).sub(neg.result()).abs().financeDiv(totalDM,
            0).mul(100).expAvg(2.0 / (period + 1))

        c = addIndicator(height)
        label1 = sprintf("+DI (%s)", period)
        label2 = sprintf("-DI (%s)", period)
        label3 = sprintf("ADX (%s)", period)
        addLineIndicator2(c, pos.result(), posColor, label1)
        addLineIndicator2(c, neg.result(), negColor, label2)
        addLineIndicator2(c, dx.result(), color, label3)
        return c
    end

    #/ <summary>
    #/ Add an Average True Range indicators chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color1">The color of the True Range line.</param>
    #/ <param name="color2">The color of the Average True Range line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addATR(height, period, color1, color2)
        trueRange = computeTrueRange()
        c = addLineIndicator(height, trueRange, color1, "True Range")
        label = sprintf("Average True Range (%s)", period)
        addLineIndicator2(c, ChartDirector::ArrayMath.new(trueRange).expAvg(2.0 / (period + 1)
            ).result(), color2, label)
        return c
    end

    #/ <summary>
    #/ Add a Bollinger Band Width indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="width">The band width to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addBollingerWidth(height, period, width, color)
        label = sprintf("Bollinger Width (%s, %s)", period, width)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).movStdDev(period
            ).mul(width * 2).result(), color, label)
    end

    #/ <summary>
    #/ Add a Community Channel Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addCCI(height, period, color, range, upColor, downColor)
        #typical price
        tp = ChartDirector::ArrayMath.new(@m_highData).add(@m_lowData).add(@m_closeData).div(3
            ).result()

        #simple moving average of typical price
        smvtp = ChartDirector::ArrayMath.new(tp).movAvg(period).result()

        #compute mean deviation
        movMeanDev = Array.new(smvtp.length)
        0.upto(smvtp.length - 1) do |i|
            avg = smvtp[i]
            if avg == ChartDirector::NoValue
                movMeanDev[i] = ChartDirector::NoValue
            else
                currentIndex = i
                count = period - 1
                acc = 0

                while (count > 0) && (currentIndex >= count)
                    currentIndex = currentIndex - 1
                    currentValue = tp[currentIndex]
                    if currentValue != ChartDirector::NoValue
                        count = count - 1
                        acc = acc + (avg - currentValue).abs
                    end
                end

                if count > 0
                    movMeanDev[i] = ChartDirector::NoValue
                else
                    movMeanDev[i] = acc / period
                end
            end
        end

        c = addIndicator(height)
        label = sprintf("CCI (%s)", period)
        layer = addLineIndicator2(c, ChartDirector::ArrayMath.new(tp).sub(smvtp).financeDiv(
            movMeanDev, 0).div(0.015).result(), color, label)
        addThreshold(c, layer, range, upColor, -range, downColor)
        return c
    end

    #/ <summary>
    #/ Add a Chaikin Money Flow indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addChaikinMoneyFlow(height, period, color)
        range = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).result()
        volAvg = ChartDirector::ArrayMath.new(@m_volData).movAvg(period).result()
        label = sprintf("Chaikin Money Flow (%s)", period)
        return addBarIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).mul(2).sub(
            @m_lowData).sub(@m_highData).mul(@m_volData).financeDiv(range, 0).movAvg(period
            ).financeDiv(volAvg, 0).result(), color, label)
    end

    #/ <summary>
    #/ Add a Chaikin Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addChaikinOscillator(height, color)
        #first compute acc/dist line
        range = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).result()
        accdist = ChartDirector::ArrayMath.new(@m_closeData).mul(2).sub(@m_lowData).sub(@m_highData
            ).mul(@m_volData).financeDiv(range, 0).acc().result()

        #chaikin osc = exp3(accdist) - exp10(accdist)
        expAvg10 = ChartDirector::ArrayMath.new(accdist).expAvg(2.0 / (10 + 1)).result()
        return addLineIndicator(height, ChartDirector::ArrayMath.new(accdist).expAvg(2.0 / (3 + 1)
            ).sub(expAvg10).result(), color, "Chaikin Oscillator")
    end

    #/ <summary>
    #/ Add a Chaikin Volatility indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The period to smooth the range.</param>
    #/ <param name="period2">The period to compute the rate of change of the smoothed range.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addChaikinVolatility(height, period1, period2, color)
        label = sprintf("Chaikin Volatility (%s, %s)", period1, period2)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData
            ).expAvg(2.0 / (period1 + 1)).rate(period2).sub(1).mul(100).result(), color, label)
    end

    #/ <summary>
    #/ Add a Close Location Value indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addCLV(height, color)
        #Close Location Value = ((C - L) - (H - C)) / (H - L)
        range = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).result()
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).mul(2).sub(
            @m_lowData).sub(@m_highData).financeDiv(range, 0).result(), color,
            "Close Location Value")
    end

    #/ <summary>
    #/ Add a Detrended Price Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addDPO(height, period, color)
        label = sprintf("DPO (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).movAvg(period
            ).shift(period / 2 + 1).sub(@m_closeData).mul(-1).result(), color, label)
    end

    #/ <summary>
    #/ Add a Donchian Channel Width indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addDonchianWidth(height, period, color)
        label = sprintf("Donchian Width (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_highData).movMax(period
            ).sub(ChartDirector::ArrayMath.new(@m_lowData).movMin(period).result()).result(), color,
            label)
    end

    #/ <summary>
    #/ Add a Ease of Movement indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to smooth the indicator.</param>
    #/ <param name="color1">The color of the indicator line.</param>
    #/ <param name="color2">The color of the smoothed indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addEaseOfMovement(height, period, color1, color2)
        boxRatioInverted = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).financeDiv(
            @m_volData, 0).result()
        result = ChartDirector::ArrayMath.new(@m_highData).add(@m_lowData).div(2).delta().mul(
            boxRatioInverted).result()

        c = addLineIndicator(height, result, color1, "EMV")
        label = sprintf("EMV EMA (%s)", period)
        addLineIndicator2(c, ChartDirector::ArrayMath.new(result).movAvg(period).result(), color2,
            label)
        return c
    end

    #/ <summary>
    #/ Add a Fast Stochastic indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The period to compute the %K line.</param>
    #/ <param name="period2">The period to compute the %D line.</param>
    #/ <param name="color1">The color of the %K line.</param>
    #/ <param name="color2">The color of the %D line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addFastStochastic(height, period1, period2, color1, color2)
        movLow = ChartDirector::ArrayMath.new(@m_lowData).movMin(period1).result()
        movRange = ChartDirector::ArrayMath.new(@m_highData).movMax(period1).sub(movLow).result()
        stochastic = ChartDirector::ArrayMath.new(@m_closeData).sub(movLow).financeDiv(movRange, 0.5
            ).mul(100).result()

        label1 = sprintf("Fast Stochastic %%K (%s)", period1)
        c = addLineIndicator(height, stochastic, color1, label1)
        label2 = sprintf("%%D (%s)", period2)
        addLineIndicator2(c, ChartDirector::ArrayMath.new(stochastic).movAvg(period2).result(),
            color2, label2)

        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a MACD indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The first moving average period to compute the indicator.</param>
    #/ <param name="period2">The second moving average period to compute the indicator.</param>
    #/ <param name="period3">The moving average period of the signal line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="signalColor">The color of the signal line.</param>
    #/ <param name="divColor">The color of the divergent bars.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addMACD(height, period1, period2, period3, color, signalColor, divColor)
        c = addIndicator(height)

        #MACD is defined as the difference between two exponential averages (typically 12/26 days)
        expAvg1 = ChartDirector::ArrayMath.new(@m_closeData).expAvg(2.0 / (period1 + 1)).result()
        macd = ChartDirector::ArrayMath.new(@m_closeData).expAvg(2.0 / (period2 + 1)).sub(expAvg1
            ).result()

        #Add the MACD line
        label1 = sprintf("MACD (%s, %s)", period1, period2)
        addLineIndicator2(c, macd, color, label1)

        #MACD signal line
        macdSignal = ChartDirector::ArrayMath.new(macd).expAvg(2.0 / (period3 + 1)).result()
        label2 = sprintf("EXP (%s)", period3)
        addLineIndicator2(c, macdSignal, signalColor, label2)

        #Divergence
        addBarIndicator2(c, ChartDirector::ArrayMath.new(macd).sub(macdSignal).result(), divColor,
            "Divergence")

        return c
    end

    #/ <summary>
    #/ Add a Mass Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addMassIndex(height, color, upColor, downColor)
        #Mass Index
        f = 2.0 / (10)
        exp9 = ChartDirector::ArrayMath.new(@m_highData).sub(@m_lowData).expAvg(f).result()
        exp99 = ChartDirector::ArrayMath.new(exp9).expAvg(f).result()

        c = addLineIndicator(height, ChartDirector::ArrayMath.new(exp9).financeDiv(exp99, 1).movAvg(
            25).mul(25).result(), color, "Mass Index")
        c.yAxis().addMark(27, upColor)
        c.yAxis().addMark(26.5, downColor)
        return c
    end

    #/ <summary>
    #/ Add a Money Flow Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addMFI(height, period, color, range, upColor, downColor)
        #Money Flow Index
        typicalPrice = ChartDirector::ArrayMath.new(@m_highData).add(@m_lowData).add(@m_closeData
            ).div(3).result()
        moneyFlow = ChartDirector::ArrayMath.new(typicalPrice).mul(@m_volData).result()

        selector = ChartDirector::ArrayMath.new(typicalPrice).delta().result()
        posMoneyFlow = ChartDirector::ArrayMath.new(moneyFlow).selectGTZ(selector).movAvg(period
            ).result()
        posNegMoneyFlow = ChartDirector::ArrayMath.new(moneyFlow).selectLTZ(selector).movAvg(period
            ).add(posMoneyFlow).result()

        c = addIndicator(height)
        label = sprintf("Money Flow Index (%s)", period)
        layer = addLineIndicator2(c, ChartDirector::ArrayMath.new(posMoneyFlow).financeDiv(
            posNegMoneyFlow, 0.5).mul(100).result(), color, label)
        addThreshold(c, layer, 50 + range, upColor, 50 - range, downColor)

        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a Momentum indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addMomentum(height, period, color)
        label = sprintf("Momentum (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).delta(period
            ).result(), color, label)
    end

    #/ <summary>
    #/ Add a Negative Volume Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the signal line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="signalColor">The color of the signal line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addNVI(height, period, color, signalColor)
        nvi = Array.new(@m_volData.length)

        previousNVI = 100
        previousVol = ChartDirector::NoValue
        previousClose = ChartDirector::NoValue
        0.upto(@m_volData.length - 1) do |i|
            if @m_volData[i] == ChartDirector::NoValue
                nvi[i] = ChartDirector::NoValue
            else
                if (previousVol != ChartDirector::NoValue) && (@m_volData[i] < previousVol) && (
                    previousClose != ChartDirector::NoValue) && (@m_closeData[i
                    ] != ChartDirector::NoValue)
                    nvi[i] = previousNVI + previousNVI * (@m_closeData[i] - previousClose
                        ) / previousClose
                else
                    nvi[i] = previousNVI
                end

                previousNVI = nvi[i]
                previousVol = @m_volData[i]
                previousClose = @m_closeData[i]
            end
        end

        c = addLineIndicator(height, nvi, color, "NVI")
        if nvi.length > period
            label = sprintf("NVI SMA (%s)", period)
            addLineIndicator2(c, ChartDirector::ArrayMath.new(nvi).movAvg(period).result(),
                signalColor, label)
        end
        return c
    end

    #/ <summary>
    #/ Add an On Balance Volume indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addOBV(height, color)
        closeChange = ChartDirector::ArrayMath.new(@m_closeData).delta().result()
        upVolume = ChartDirector::ArrayMath.new(@m_volData).selectGTZ(closeChange).result()
        downVolume = ChartDirector::ArrayMath.new(@m_volData).selectLTZ(closeChange).result()

        return addLineIndicator(height, ChartDirector::ArrayMath.new(upVolume).sub(downVolume).acc(
            ).result(), color, "OBV")
    end

    #/ <summary>
    #/ Add a Performance indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addPerformance(height, color)
        closeValue = firstCloseValue()
        if closeValue != ChartDirector::NoValue
            return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).mul(
                100 / closeValue).sub(100).result(), color, "Performance")
        else
            #chart is empty !!!
            return addIndicator(height)
        end
    end

    #/ <summary>
    #/ Add a Percentage Price Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The first moving average period to compute the indicator.</param>
    #/ <param name="period2">The second moving average period to compute the indicator.</param>
    #/ <param name="period3">The moving average period of the signal line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="signalColor">The color of the signal line.</param>
    #/ <param name="divColor">The color of the divergent bars.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addPPO(height, period1, period2, period3, color, signalColor, divColor)
        expAvg1 = ChartDirector::ArrayMath.new(@m_closeData).expAvg(2.0 / (period1 + 1)).result()
        expAvg2 = ChartDirector::ArrayMath.new(@m_closeData).expAvg(2.0 / (period2 + 1)).result()
        ppo = ChartDirector::ArrayMath.new(expAvg2).sub(expAvg1).financeDiv(expAvg2, 0).mul(100)
        ppoSignal = ChartDirector::ArrayMath.new(ppo.result()).expAvg(2.0 / (period3 + 1)).result()

        label1 = sprintf("PPO (%s, %s)", period1, period2)
        label2 = sprintf("EMA (%s)", period3)
        c = addLineIndicator(height, ppo.result(), color, label1)
        addLineIndicator2(c, ppoSignal, signalColor, label2)
        addBarIndicator2(c, ppo.sub(ppoSignal).result(), divColor, "Divergence")
        return c
    end

    #/ <summary>
    #/ Add a Positive Volume Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the signal line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="signalColor">The color of the signal line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addPVI(height, period, color, signalColor)
        #Positive Volume Index
        pvi = Array.new(@m_volData.length)

        previousPVI = 100
        previousVol = ChartDirector::NoValue
        previousClose = ChartDirector::NoValue
        0.upto(@m_volData.length - 1) do |i|
            if @m_volData[i] == ChartDirector::NoValue
                pvi[i] = ChartDirector::NoValue
            else
                if (previousVol != ChartDirector::NoValue) && (@m_volData[i] > previousVol) && (
                    previousClose != ChartDirector::NoValue) && (@m_closeData[i
                    ] != ChartDirector::NoValue)
                    pvi[i] = previousPVI + previousPVI * (@m_closeData[i] - previousClose
                        ) / previousClose
                else
                    pvi[i] = previousPVI
                end

                previousPVI = pvi[i]
                previousVol = @m_volData[i]
                previousClose = @m_closeData[i]
            end
        end

        c = addLineIndicator(height, pvi, color, "PVI")
        if pvi.length > period
            label = sprintf("PVI SMA (%s)", period)
            addLineIndicator2(c, ChartDirector::ArrayMath.new(pvi).movAvg(period).result(),
                signalColor, label)
        end
        return c
    end

    #/ <summary>
    #/ Add a Percentage Volume Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The first moving average period to compute the indicator.</param>
    #/ <param name="period2">The second moving average period to compute the indicator.</param>
    #/ <param name="period3">The moving average period of the signal line.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="signalColor">The color of the signal line.</param>
    #/ <param name="divColor">The color of the divergent bars.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addPVO(height, period1, period2, period3, color, signalColor, divColor)
        expAvg1 = ChartDirector::ArrayMath.new(@m_volData).expAvg(2.0 / (period1 + 1)).result()
        expAvg2 = ChartDirector::ArrayMath.new(@m_volData).expAvg(2.0 / (period2 + 1)).result()
        pvo = ChartDirector::ArrayMath.new(expAvg2).sub(expAvg1).financeDiv(expAvg2, 0).mul(100)
        pvoSignal = ChartDirector::ArrayMath.new(pvo.result()).expAvg(2.0 / (period3 + 1)).result()

        label1 = sprintf("PVO (%s, %s)", period1, period2)
        label2 = sprintf("EMA (%s)", period3)
        c = addLineIndicator(height, pvo.result(), color, label1)
        addLineIndicator2(c, pvoSignal, signalColor, label2)
        addBarIndicator2(c, pvo.sub(pvoSignal).result(), divColor, "Divergence")
        return c
    end

    #/ <summary>
    #/ Add a Price Volumne Trend indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addPVT(height, color)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).rate().sub(1
            ).mul(@m_volData).acc().result(), color, "PVT")
    end

    #/ <summary>
    #/ Add a Rate of Change indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addROC(height, period, color)
        label = sprintf("ROC (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).rate(period).sub(
            1).mul(100).result(), color, label)
    end

    def RSIMovAvg(data, period)
        #The "moving average" in classical RSI is based on a formula that mixes simple
        #and exponential moving averages.

        if period <= 0
            period = 1
        end

        count = 0
        acc = 0

        0.upto(data.length - 1) do |i|
            if (data[i] / ChartDirector::NoValue - 1).abs > 1e-005
                count = count + 1
                acc = acc + data[i]
                if count < period
                    data[i] = ChartDirector::NoValue
                else
                    data[i] = acc / period
                    acc = data[i] * (period - 1)
                end
            end
        end

        return data
    end

    def computeRSI(period)
        #RSI is defined as the average up changes for the last 14 days, divided by the
        #average absolute changes for the last 14 days, expressed as a percentage.

        absChange = RSIMovAvg(ChartDirector::ArrayMath.new(@m_closeData).delta().abs().result(),
            period)
        absUpChange = RSIMovAvg(ChartDirector::ArrayMath.new(@m_closeData).delta().selectGTZ(
            ).result(), period)
        return ChartDirector::ArrayMath.new(absUpChange).financeDiv(absChange, 0.5).mul(100).result(
            )
    end

    #/ <summary>
    #/ Add a Relative Strength Index indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addRSI(height, period, color, range, upColor, downColor)
        c = addIndicator(height)
        label = sprintf("RSI (%s)", period)
        layer = addLineIndicator2(c, computeRSI(period), color, label)

        #Add range if given
        if (range > 0) && (range < 50)
            addThreshold(c, layer, 50 + range, upColor, 50 - range, downColor)
        end
        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a Slow Stochastic indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The period to compute the %K line.</param>
    #/ <param name="period2">The period to compute the %D line.</param>
    #/ <param name="color1">The color of the %K line.</param>
    #/ <param name="color2">The color of the %D line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addSlowStochastic(height, period1, period2, color1, color2)
        movLow = ChartDirector::ArrayMath.new(@m_lowData).movMin(period1).result()
        movRange = ChartDirector::ArrayMath.new(@m_highData).movMax(period1).sub(movLow).result()
        stochastic = ChartDirector::ArrayMath.new(@m_closeData).sub(movLow).financeDiv(movRange, 0.5
            ).mul(100).movAvg(3)

        label1 = sprintf("Slow Stochastic %%K (%s)", period1)
        label2 = sprintf("%%D (%s)", period2)
        c = addLineIndicator(height, stochastic.result(), color1, label1)
        addLineIndicator2(c, stochastic.movAvg(period2).result(), color2, label2)

        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a Moving Standard Deviation indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addStdDev(height, period, color)
        label = sprintf("Moving StdDev (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).movStdDev(period
            ).result(), color, label)
    end

    #/ <summary>
    #/ Add a Stochastic RSI indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addStochRSI(height, period, color, range, upColor, downColor)
        rsi = computeRSI(period)
        movLow = ChartDirector::ArrayMath.new(rsi).movMin(period).result()
        movRange = ChartDirector::ArrayMath.new(rsi).movMax(period).sub(movLow).result()

        c = addIndicator(height)
        label = sprintf("StochRSI (%s)", period)
        layer = addLineIndicator2(c, ChartDirector::ArrayMath.new(rsi).sub(movLow).financeDiv(
            movRange, 0.5).mul(100).result(), color, label)

        #Add range if given
        if (range > 0) && (range < 50)
            addThreshold(c, layer, 50 + range, upColor, 50 - range, downColor)
        end
        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a TRIX indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addTRIX(height, period, color)
        f = 2.0 / (period + 1)
        label = sprintf("TRIX (%s)", period)
        return addLineIndicator(height, ChartDirector::ArrayMath.new(@m_closeData).expAvg(f).expAvg(
            f).expAvg(f).rate().sub(1).mul(100).result(), color, label)
    end

    def computeTrueLow()
        #the lower of today's low or yesterday's close.
        previousClose = ChartDirector::ArrayMath.new(@m_closeData).shift().result()
        ret = Array.new(@m_lowData.length)
        0.upto(@m_lowData.length - 1) do |i|
            if (@m_lowData[i] != ChartDirector::NoValue) && (previousClose[i
                ] != ChartDirector::NoValue)
                if @m_lowData[i] < previousClose[i]
                    ret[i] = @m_lowData[i]
                else
                    ret[i] = previousClose[i]
                end
            else
                ret[i] = ChartDirector::NoValue
            end
        end

        return ret
    end

    #/ <summary>
    #/ Add an Ultimate Oscillator indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period1">The first moving average period to compute the indicator.</param>
    #/ <param name="period2">The second moving average period to compute the indicator.</param>
    #/ <param name="period3">The third moving average period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addUltimateOscillator(height, period1, period2, period3, color, range, upColor, downColor)
        trueLow = computeTrueLow()
        buyingPressure = ChartDirector::ArrayMath.new(@m_closeData).sub(trueLow).result()
        trueRange = computeTrueRange()

        rawUO1 = ChartDirector::ArrayMath.new(buyingPressure).movAvg(period1).financeDiv(
            ChartDirector::ArrayMath.new(trueRange).movAvg(period1).result(), 0.5).mul(4).result()
        rawUO2 = ChartDirector::ArrayMath.new(buyingPressure).movAvg(period2).financeDiv(
            ChartDirector::ArrayMath.new(trueRange).movAvg(period2).result(), 0.5).mul(2).result()
        rawUO3 = ChartDirector::ArrayMath.new(buyingPressure).movAvg(period3).financeDiv(
            ChartDirector::ArrayMath.new(trueRange).movAvg(period3).result(), 0.5).mul(1).result()

        c = addIndicator(height)
        label = sprintf("Ultimate Oscillator (%s, %s, %s)", period1, period2, period3)
        layer = addLineIndicator2(c, ChartDirector::ArrayMath.new(rawUO1).add(rawUO2).add(rawUO3
            ).mul(100.0 / 7).result(), color, label)
        addThreshold(c, layer, 50 + range, upColor, 50 - range, downColor)

        c.yAxis().setLinearScale(0, 100)
        return c
    end

    #/ <summary>
    #/ Add a Volume indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="upColor">The color to used on an 'up' day. An 'up' day is a day where
    #/ the closing price is higher than that of the previous day.</param>
    #/ <param name="downColor">The color to used on a 'down' day. A 'down' day is a day
    #/ where the closing price is lower than that of the previous day.</param>
    #/ <param name="flatColor">The color to used on a 'flat' day. A 'flat' day is a day
    #/ where the closing price is the same as that of the previous day.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addVolIndicator(height, upColor, downColor, flatColor)
        c = addIndicator(height)
        addVolBars2(c, height, upColor, downColor, flatColor)
        return c
    end

    #/ <summary>
    #/ Add a William %R indicator chart.
    #/ </summary>
    #/ <param name="height">The height of the indicator chart in pixels.</param>
    #/ <param name="period">The period to compute the indicator.</param>
    #/ <param name="color">The color of the indicator line.</param>
    #/ <param name="range">The distance beween the middle line and the upper and lower threshold lines.</param>
    #/ <param name="upColor">The fill color when the indicator exceeds the upper threshold line.</param>
    #/ <param name="downColor">The fill color when the indicator falls below the lower threshold line.</param>
    #/ <returns>The XYChart object representing the chart created.</returns>
    def addWilliamR(height, period, color, range, upColor, downColor)
        movLow = ChartDirector::ArrayMath.new(@m_lowData).movMin(period).result()
        movHigh = ChartDirector::ArrayMath.new(@m_highData).movMax(period).result()
        movRange = ChartDirector::ArrayMath.new(movHigh).sub(movLow).result()

        c = addIndicator(height)
        layer = addLineIndicator2(c, ChartDirector::ArrayMath.new(movHigh).sub(@m_closeData
            ).financeDiv(movRange, 0.5).mul(-100).result(), color, "William %R")
        addThreshold(c, layer, -50 + range, upColor, -50 - range, downColor)
        c.yAxis().setLinearScale(-100, 0)
        return c
    end
end
