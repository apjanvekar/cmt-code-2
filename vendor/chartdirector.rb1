module ChartDirector
CDRBVersion = 0x500

if RUBY_VERSION < "1.9"
	CDAPISO = "rubycdapi18"
else
	CDAPISO = "rubycdapi191"
end

begin
	require(File.join(File.dirname(__FILE__), CDAPISO))
rescue Exception
	require(CDAPISO)
end
module_function

# short cut
def _r(*args)
	args.each_index do |i|
		a = args[i]
		if a.is_a?(Array)
			a.each do |e|
				if e.is_a?(Time)
					args[i] = a.collect { |v| v.is_a?(Time) ? chartTime2(v.to_f) : v }
					break
				end
			end
		elsif a.is_a?(Time)
			args[i] = chartTime2(a.to_f)
		end
	end
	RubyCdApi.callMethod(*args)
end

# version checking
dllVersion = _r("getVersion") >> 16
if dllVersion != CDRBVersion
	raise LoadError, "Version mismatch - 'rubychartdir.rb' is of version #{(CDRBVersion >> 8) & 0xff}.#{CDRBVersion & 0xff}, but 'chartdir.dll/libchartdir.so' is of version #{(dllVersion >> 8) & 0xff}.#{dllVersion & 0xff}"
end

class AutoMethod
	attr_reader :this
	protected :this

	def initialize(this)
		@this = this
	end

	def destructor(name, this)
		ObjectSpace.define_finalizer(self, AutoMethod.createDestructor(name, this))
	end

	def AutoMethod.createDestructor(name, this)
		return proc { ChartDirector._r(name, this) }
	end

	def _r(*args)
		ChartDirector._r(*args)
	end
	
	def getClassName(name)
		pos = name.rindex(':')
		if pos
			return name[pos + 1 .. -1]
		else
			return name
		end
	end			
	
	def cdFindSubClass(c)
		while c
			return c if AllClasses.has_key?(c)
			c = c.superclass
		end
		return nil
	end
		
	def cdFindDefaultArgs(c, varName)
		while c
			if c.const_defined?("DefaultArgs")
				ret = c.const_get("DefaultArgs")[varName]
				if ret
					return ret
				end
			end
			c = c.superclass
		end
		return nil	
	end

	def encodeIfArray(b, a)
		return (a.class == Array) ? b + "2" : b
	end

	def decodePtr(p)
		if not p
			return '$$pointer$$null'
		elsif p.respond_to?("this")
			return p.this
		else
			return p
		end
	end

	def method_missing(name, *args)
		classObj = cdFindSubClass(self.class)
		if not classObj
			classObj = self.class
		end
		defaultArgs = cdFindDefaultArgs(classObj, name.id2name)
		if defaultArgs and defaultArgs.length > 1
			if args.length < defaultArgs[1] - defaultArgs.length + 2
				raise ArgumentError, sprintf("Wrong number of arguments; expecting at least %d but received %d", defaultArgs[1] - defaultArgs.length + 2, args.length)
			end
			if args.length < defaultArgs[1]
				args = args + defaultArgs[(defaultArgs.length - defaultArgs[1] + args.length) .. -1]
			end
		end
		ret = _r(getClassName(classObj.name) + "." + name.id2name, @this, *args)
		if defaultArgs and defaultArgs.length > 0 and defaultArgs[0]
			return defaultArgs[0].new(ret)
		else
			return ret
		end
	end
end

#
# constants
#

BottomLeft = 1
BottomCenter = 2
BottomRight = 3	
Left = 4
Center = 5
Right = 6
TopLeft = 7
TopCenter = 8
TopRight = 9
Top = TopCenter
Bottom = BottomCenter
TopLeft2 = 10
TopRight2 = 11
BottomLeft2 = 12
BottomRight2 = 13

Transparent = 0xff000000
Palette = 0xffff0000
BackgroundColor = 0xffff0000
LineColor = 0xffff0001
TextColor = 0xffff0002
DataColor = 0xffff0008
SameAsMainColor = 0xffff0007

HLOCDefault = 0
HLOCOpenClose = 1
HLOCUpDown = 2

DiamondPointer = 0
TriangularPointer = 1
ArrowPointer = 2
ArrowPointer2 = 3
LinePointer = 4
PencilPointer = 5

ChartBackZ = 0x100
ChartFrontZ = 0xffff
PlotAreaZ = 0x1000
GridLinesZ = 0x2000

XAxisSymmetric = 1
XAxisSymmetricIfNeeded = 2
YAxisSymmetric = 4
YAxisSymmetricIfNeeded = 8
XYAxisSymmetric = 16
XYAxisSymmetricIfNeeded = 32

XAxisAtOrigin = 1
YAxisAtOrigin = 2
XYAxisAtOrigin = 3
	
# need to * 1e100 to get around ruby bugs
C1E308 = 1e208 * 1e100
C17E308 = 1.7 * C1E308
NoValue = C17E308
LogTick = 1.6e208 * 1e100
LinearTick = 1.5e208 * 1e100
TickInc = 1e200
MinorTickOnly = -C17E308
MicroTickOnly = -1.6e208 * 1e100
TouchBar = -1.7e-100
AutoGrid = -2

NoAntiAlias = 0
AntiAlias = 1
AutoAntiAlias = 2

TryPalette = 0
ForcePalette = 1
NoPalette = 2
Quantize = 0
OrderedDither = 1
ErrorDiffusion = 2

BoxFilter = 0
LinearFilter = 1
QuadraticFilter = 2
BSplineFilter = 3
HermiteFilter = 4
CatromFilter = 5
MitchellFilter = 6
SincFilter = 7
LanczosFilter = 8
GaussianFilter = 9
HanningFilter = 10
HammingFilter = 11
BlackmanFilter = 12
BesselFilter = 13

PNG = 0
GIF = 1
JPG = 2
WMP = 3
BMP = 4
SVG = 5
SVGZ = 6

Overlay = 0
Stack = 1
Depth = 2
Side = 3
Percentage = 4

def defaultPalette 
	[
	0xffffff, 0x000000, 0x000000, 0x808080, 
	0x808080, 0x808080, 0x808080, 0x808080,
	0xff3333, 0x33ff33, 0x6666ff, 0xffff00, 
	0xff66ff, 0x99ffff,	0xffcc33, 0xcccccc, 
	0xcc9999, 0x339966, 0x999900, 0xcc3300,	
	0x669999, 0x993333, 0x006600, 0x990099,
	0xff9966, 0x99ff99, 0x9999ff, 0xcc6600,
	0x33cc33, 0xcc99ff, 0xff6666, 0x99cc66,
	0x009999, 0xcc3333, 0x9933ff, 0xff0000,
	0x0000ff, 0x00ff00, 0xffcc99, 0x999999,
	-1
	]
end

def whiteOnBlackPalette
	[
	0x000000, 0xffffff, 0xffffff, 0x808080, 
	0x808080, 0x808080, 0x808080, 0x808080,
	0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 
	0xff00ff, 0x66ffff,	0xffcc33, 0xcccccc, 
	0x9966ff, 0x339966, 0x999900, 0xcc3300,	
	0x99cccc, 0x006600, 0x660066, 0xcc9999,
	0xff9966, 0x99ff99, 0x9999ff, 0xcc6600,
	0x33cc33, 0xcc99ff, 0xff6666, 0x99cc66,
	0x009999, 0xcc3333, 0x9933ff, 0xff0000,
	0x0000ff, 0x00ff00, 0xffcc99, 0x999999,
	-1
	]
end

def transparentPalette
	[ 
	0xffffff, 0x000000, 0x000000, 0x808080, 
	0x808080, 0x808080, 0x808080, 0x808080,
	0x80ff0000, 0x8000ff00, 0x800000ff, 0x80ffff00, 
	0x80ff00ff, 0x8066ffff, 0x80ffcc33, 0x80cccccc, 
	0x809966ff, 0x80339966, 0x80999900, 0x80cc3300,
	0x8099cccc, 0x80006600, 0x80660066, 0x80cc9999,
	0x80ff9966, 0x8099ff99, 0x809999ff, 0x80cc6600,
	0x8033cc33, 0x80cc99ff, 0x80ff6666, 0x8099cc66,
	0x80009999, 0x80cc3333, 0x809933ff, 0x80ff0000,
	0x800000ff, 0x8000ff00, 0x80ffcc99, 0x80999999,
	-1
	]
end

NoSymbol = 0
SquareSymbol = 1
DiamondSymbol = 2
TriangleSymbol = 3
RightTriangleSymbol = 4
LeftTriangleSymbol = 5
InvertedTriangleSymbol = 6
CircleSymbol = 7
CrossSymbol = 8
Cross2Symbol = 9
PolygonSymbol = 11
Polygon2Symbol = 12
StarSymbol = 13
CustomSymbol = 14 
	
NoShape = 0
SquareShape = 1
DiamondShape = 2
TriangleShape = 3
RightTriangleShape = 4
LeftTriangleShape = 5
InvertedTriangleShape = 6
CircleShape = 7
CircleShapeNoShading = 10
GlassSphereShape = 15
GlassSphere2Shape = 16
SolidSphereShape = 17

def cdBound(a, b, c)
	if b < a
		return a
	elsif b > c
		return c
	else
		return b
	end
end
private_class_method :cdBound

def CrossShape(width = 0.5)
	return CrossSymbol | ((cdBound(0, width, 1) * 4095 + 0.5).to_i << 12)
end
def Cross2Shape(width = 0.5)
	return Cross2Symbol | ((cdBound(0, width, 1) * 4095 + 0.5).to_i << 12)
end
def PolygonShape(side)
	return PolygonSymbol | (cdBound(0, side, 100).to_i << 12)
end
def Polygon2Shape(side)
	return Polygon2Symbol | (cdBound(0, side, 100).to_i << 12)
end
def StarShape(side)
	return StarSymbol | (cdBound(0, side, 100).to_i << 12)
end

DashLine = 0x0505
DotLine = 0x0202
DotDashLine = 0x05050205
AltDashLine = 0x0A050505

def goldGradient
	[0, 0xFFE743, 0x60, 0xFFFFE0, 0xB0, 0xFFF0B0, 0x100, 0xFFE743]
end
def silverGradient
	[0, 0xC8C8C8, 0x60, 0xF8F8F8, 0xB0, 0xE0E0E0, 0x100, 0xC8C8C8]
end
def redMetalGradient
	[0, 0xE09898, 0x60, 0xFFF0F0, 0xB0, 0xF0D8D8, 0x100, 0xE09898]
end
def blueMetalGradient
	[0, 0x9898E0, 0x60, 0xF0F0FF, 0xB0, 0xD8D8F0, 0x100, 0x9898E0]
end
def greenMetalGradient
	[0, 0x98E098, 0x60, 0xF0FFF0, 0xB0, 0xD8F0D8, 0x100, 0x98E098]
end

def metalColor(c, angle = 90)
	return _r("metalColor", c, angle)
end
def goldColor(angle = 90)
	return metalColor(0xffee44, angle)
end
def silverColor(angle = 90)
	return metalColor(0xdddddd, angle)
end

def brushedMetalColor(c, texture = 2, angle = 90)
	return metalColor(c, angle) | ((texture & 0x3) << 18)
end
def brushedSilverColor(texture = 2, angle = 90)
	return brushedMetalColor(0xdddddd, texture, angle)
end
def brushedGoldColor(texture = 2, angle = 90)
	return brushedMetalColor(0xffee44, texture, angle)
end

DefaultShading = 0
FlatShading = 1
LocalGradientShading = 2
GlobalGradientShading = 3
ConcaveShading = 4
RoundedEdgeNoGlareShading = 5
RoundedEdgeShading = 6
RadialShading = 7
RingShading = 8

SmoothShading = 0
TriangularShading = 1
RectangularShading = 2
TriangularFrame = 3
RectangularFrame = 4

SideLayout = 0
CircleLayout = 1

NormalLegend = 0
ReverseLegend = 1
NoLegend = 2

PixelScale = 0
XAxisScale = 1
YAxisScale = 2
EndPoints = 3
AngularAxisScale = XAxisScale
RadialAxisScale = YAxisScale

MonotonicNone = 0 
MonotonicX = 1
MonotonicY = 2
MonotonicXY = 3
MonotonicAuto = 4

ConstrainedLinearRegression = 0
LinearRegression = 1
ExponentialRegression = -1
LogarithmicRegression = -2

def PolynomialRegression(n)
	return n
end

StartOfHourFilterTag = 1
StartOfDayFilterTag = 2
StartOfWeekFilterTag = 3
StartOfMonthFilterTag = 4
StartOfYearFilterTag = 5
RegularSpacingFilterTag = 6
AllPassFilterTag = 7
NonePassFilterTag = 8
SelectItemFilterTag = 9

def StartOfHourFilter(labelStep = 1, initialMargin = 0.05)
	return _r("encodeFilter", StartOfHourFilterTag, labelStep, initialMargin)
end
def StartOfDayFilter(labelStep = 1, initialMargin = 0.05)
	return _r("encodeFilter", StartOfDayFilterTag, labelStep, initialMargin)
end
def StartOfWeekFilter(labelStep = 1, initialMargin = 0.05)
	return _r("encodeFilter", StartOfWeekFilterTag, labelStep, initialMargin)
end
def StartOfMonthFilter(labelStep = 1, initialMargin = 0.05)
	return _r("encodeFilter", StartOfMonthFilterTag, labelStep, initialMargin)
end
def StartOfYearFilter(labelStep = 1, initialMargin = 0.05)
	return _r("encodeFilter", StartOfYearFilterTag, labelStep, initialMargin)
end
def RegularSpacingFilter(labelStep = 1, initialMargin = 0)
	return _r("encodeFilter", RegularSpacingFilterTag, labelStep, initialMargin / 4095.0)
end
def AllPassFilter()
	return _r("encodeFilter", AllPassFilterTag, 0, 0)
end
def NonePassFilter()
	return _r("encodeFilter", NonePassFilterTag, 0, 0)
end
def SelectItemFilter(item)
	return _r("encodeFilter", SelectItemFilterTag, item, 0)
end
	
NormalGlare = 3
ReducedGlare = 2
NoGlare	= 1

def glassEffect(glareSize = NormalGlare, glareDirection = Top, raisedEffect = 5)
	return _r("glassEffect", glareSize, glareDirection, raisedEffect)
end
def softLighting(direction = Top, raisedEffect = 4)
	return _r("softLighting", direction, raisedEffect)
end
def barLighting(startBrightness = 0.75, endBrightness = 1.5)
	return _r("barLighting", startBrightness, endBrightness)
end
def cylinderEffect(orientation = Center, ambientIntensity = 0.5, diffuseIntensity = 0.5, specularIntensity = 0.75, shininess = 8)
	return _r("cylinderEffect", orientation, ambientIntensity, diffuseIntensity, specularIntensity, shininess)
end

AggregateSum = 0
AggregateAvg = 1
AggregateStdDev = 2
AggregateMin = 3
AggregateMed = 4
AggregateMax = 5
AggregatePercentile = 6
AggregateFirst = 7
AggregateLast = 8
AggregateCount = 9

#
# bindings to libgraphics.h
#

class TTFText < AutoMethod
	DefaultArgs = {
		"draw" => [nil, 4, TopLeft]
	}
	def initialize(this, parent)
		@this = this
		@parent = parent
		destructor("TTFText.destroy", this)
	end
end

class DrawArea < AutoMethod
	DefaultArgs = {
		"setSize" => [nil, 3, 0xffffff],
		"resize" => [nil, 4, LinearFilter, 1],
		"move" => [nil, 5, 0xffffff, LinearFilter, 1],
		"rotate" => [nil, 6, 0xffffff, -1, -1, LinearFilter, 1],
		"line" => [nil, 6, 1],
		"rect" => [nil, 7, 0],
		"text2" => [nil, 11, TopLeft],
		"rAffineTransform" => [nil, 9, 0xffffff, LinearFilter, 1],
		"affineTransform" => [nil, 9, 0xffffff, LinearFilter, 1],
		"sphereTransform" => [nil, 5, 0xffffff, LinearFilter, 1],
		"hCylinderTransform" => [nil, 4, 0xffffff, LinearFilter, 1],
		"vCylinderTransform" => [nil, 4, 0xffffff, LinearFilter, 1],
		"vTriangleTransform" => [nil, 4, -1, 0xffffff, LinearFilter, 1],
		"hTriangleTransform" => [nil, 4, -1, 0xffffff, LinearFilter, 1],
		"shearTransform" => [nil, 5, 0, 0xffffff, LinearFilter, 1],
		"waveTransform" => [nil, 8, 0, 0, false, 0xffffff, LinearFilter, 1],
		"outJPG" => [nil, 2, 80],
		"outSVG" => [nil, 2, ""],
		"outJPG2" => [nil, 1, 80],
		"outSVG2" => [nil, 1, ""],
		"setAntiAlias" => [nil, 2, 1, AutoAntiAlias],
		"dashLineColor" => [nil, 2, DashLine],
		"patternColor2" => [nil, 3, 0, 0],
		"gradientColor2" => [nil, 5, 90, 1, 0, 0],
		"setDefaultFonts" => [nil, 4, "", "", ""],
		"reduceColors" => [nil, 2, false],
		"linearGradientColor" => [nil, 7, false],
		"linearGradientColor2" => [nil, 6, false],
		"radialGradientColor" => [nil, 7, false],
		"radialGradientColor2" => [nil, 6, false]
		}
	def initialize(this = nil)
		if not this
			this = @this = _r("DrawArea.create")
			destructor("DrawArea.destroy", this)
		else
			@this = this
		end
	end
	def clone(d, x, y, align, newWidth = -1, newHeight = -1, ft = LinearFilter, blur = 1)
		_r("DrawArea.clone", @this, d.this, x, y, align, newWidth, newHeight, ft, blur)
	end
	def polygon(points, edgeColor, fillColor)
		_r("DrawArea.polygon", @this, points.collect { |a| a[0] }, points.collect { |a| a[1] }, edgeColor, fillColor)
	end
	def fill(x, y, color, borderColor = nil)
		if not borderColor
			_r("DrawArea.fill", @this, x, y, color)
		else
			fill2(x, y, color, borderColor)
		end
	end
	def text3(str, font, fontSize)
		return TTFText.new(_r("DrawArea.text3", @this, str, font, fontSize), self)
	end
	def text4(text, font, fontIndex, fontHeight, fontWidth, angle, vertical)
		return TTFText.new(_r("DrawArea.text4", @this, text, font, fontIndex, fontHeight, fontWidth, angle, vertical), self)
	end
	def merge(d, x, y, align, transparency)
		_r("DrawArea.merge", @this, d.this, x, y, align, transparency)
	end
	def tile(d, transparency)
		_r("DrawArea.tile", @this, d.this, transparency)
	end
	def patternColor(c, h = nil, startX = 0, startY = 0)
		if not h
			return patternColor2(c)
		else
			return _r("DrawArea.patternColor", @this, c, h, startX, startY)
		end
	end
	def gradientColor(startX, startY = 90, endX = 1, endY = 0, startColor = 0, endColor = nil)
		if not endColor
			return gradientColor2(startX, startY, endX, endY, startColor)
		else
			return _r("DrawArea.gradientColor", @this, startX, startY, endX, endY, startColor, endColor)
		end
	end
end

#
# bindings to drawobj.h
#

class Box < AutoMethod
	DefaultArgs = {
		"setBackground" => [nil, 3, -1, 0],
		"getImageCoor" => [nil, 2, 0, 0],
		"setRoundedCorners" => [nil, 4, 10, -1, -1, -1]
	}
end

class TextBox < Box
	DefaultArgs = {
		"setFontStyle" => [nil, 2, 0],
		"setFontSize" => [nil, 2, 0],
		"setFontAngle" => [nil, 2, false],
		"setTruncate" => [nil, 2, 1] 
	}
end
	
class Line < AutoMethod 
end
	
class CDMLTable < AutoMethod
	DefaultArgs = {
		"setPos" => [nil, 3, TopLeft],
		"insertCol" => [TextBox, 1],
		"appendCol" => [TextBox, 0],
		"insertRow" => [TextBox, 1],
		"appendRow" => [TextBox, 0],
		"setText" => [TextBox, 3],
		"setCell" => [TextBox, 5],
		"getCell" => [TextBox, 2],
		"getColStyle" => [TextBox, 1],
		"getRowStyle" => [TextBox, 1],
		"getStyle" => [TextBox, 0]
	}
end

#
# bindings to basechart.h
#

class LegendBox < TextBox
	DefaultArgs = {
		"setKeySize" => [nil, 3, -1, -1],
		"setKeySpacing" => [nil, 2, -1],
		"setKeyBorder" => [nil, 2, 0],
		"setReverse" => [nil, 1, 1],
		"setLineStyleKey" => [nil, 1, 1],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0]		
	}
	def addKey(text, color, lineWidth = 0, drawarea = nil)
		_r("LegendBox.addKey", @this, text, color, lineWidth, decodePtr(drawarea))
	end
	def	addKey2(pos, text, color, lineWidth = 0, drawarea = nil)
		_r("LegendBox.addKey2", @this, pos, text, color, lineWidth, decodePtr(drawarea))
	end
	def getImageCoor2(dataItem, offsetX = 0, offsetY = 0)
		return _r("LegendBox.getImageCoor", @this, dataItem, offsetX, offsetY)
	end
end

class BaseChart < AutoMethod
	DefaultArgs = {
		"setBackground" => [nil, 3, -1, 0],
		"setBgImage" => [nil, 2, Center],
		"setDropShadow" => [nil, 4, 0xaaaaaa, 5, 0x7fffffff, 5],
		"setAntiAlias" => [nil, 2, 1, AutoAntiAlias],
		"addTitle2" => [TextBox, 7, "", 12, TextColor, Transparent, Transparent],
		"addTitle" => [TextBox, 6, "", 12, TextColor, Transparent, Transparent],
		"addLegend" => [LegendBox, 5, 1, "", 10],
		"addLegend2" => [LegendBox, 5, 1, "", 10],
		"getLegend" => [LegendBox, 0],
		"layoutLegend" => [LegendBox, 0],
		"getDrawArea" => [DrawArea, 0],
		"addText" => [TextBox, 9, "", 8, TextColor, TopLeft, 0, false],
		"addLine" => [Line, 6, LineColor, 1],
		"addTable" => [CDMLTable, 5],
		"dashLineColor" => [nil, 2, DashLine],
		"patternColor2" => [nil, 3, 0, 0],
		"gradientColor2" => [nil, 5, 90, 1, 0, 0],
		"setDefaultFonts" => [nil, 4, "", "", ""],
		"setNumberFormat" => [nil, 3, "~", ".", "-"],
		"makeChart3" => [DrawArea, 0],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0],
		"setRoundedFrame" => [nil, 5, 0xffffff, 10, -1, -1, -1],
		"linearGradientColor" => [nil, 7, false],
		"linearGradientColor2" => [nil, 6, false],
		"radialGradientColor" => [nil, 7, false],
		"radialGradientColor2" => [nil, 6, false]
		}
	def initialize(this)
		@this = this
		destructor("BaseChart.destroy", this)
	end
	def patternColor(c, h = nil, startX = 0, startY = 0)
		if not h
			return patternColor2(c)
		else
			return _r("BaseChart.patternColor", @this, c, h, startX, startY)
		end
	end
	def gradientColor(startX, startY = 90, endX = 1, endY = 0, startColor = 0, endColor = nil)
		if not endColor
			return gradientColor2(startX, startY, endX, endY, startColor)
		else
			return _r("BaseChart.gradientColor", @this, startX, startY, endX, endY, startColor, endColor)
		end
	end
	def makeTmpFile(path, imageFormat = PNG, lifeTime = 600)
		path = ChartDirector::normalizePath(path)
		ext = case imageFormat
			when JPG then ".jpg"
			when GIF then ".gif"
			when BMP then ".bmp"
			when WMP then ".wbmp"
			when SVG then ".svg"
			when SVGZ then ".svgz"
			else ".png"
		end
		filename = ChartDirector::tmpFile2(path, lifeTime, ext)
		if makeChart(path + "/" + filename)
			return filename
		else
			return ""
		end
	end
end

class MultiChart < BaseChart
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("MultiChart.create", width, height, bgColor, edgeColor, raisedEffect))
		@dependencies = []
	end
	def addChart(x, y, c)
		_r("MultiChart.addChart", @this, x, y, c.this)
		@dependencies.push(c)
	end
	def setMainChart(c)
		_r("MultiChart.setMainChart", @this, c.this)
	end
end

#
# bindings to piechart.h
#
class Sector < AutoMethod
	DefaultArgs = {
		"setExplode" => [nil, 1, -1],
		"setLabelStyle" => [TextBox, 3, "", 8, TextColor],
		"setLabelPos" => [nil, 2, -1],
		"setLabelLayout" => [nil, 2, -1],
		"setJoinLine" => [nil, 2, 1],
		"setColor" => [nil, 3, -1, -1],
		"setStyle" => [nil, 3, -1, -1],
		"getImageCoor" => [nil, 2, 0, 0],
		"getLabelCoor" => [nil, 2, 0, 0]
		}
end

class PieChart < BaseChart
	DefaultArgs = {
		"setStartAngle" => [nil, 2, 1],
		"setExplode" => [nil, 2, -1, -1],
		"setExplodeGroup" => [nil, 3, -1],
		"setLabelStyle" => [TextBox, 3, "", 8, TextColor],
		"setLabelPos" => [nil, 2, -1],
		"setLabelLayout" => [nil, 4, -1, -1, -1],
		"setJoinLine" => [nil, 2, 1],
		"setLineColor" => [nil, 2, -1],
		"setSectorStyle" => [nil, 3, -1, -1],
		"setData" => [nil, 2, nil],
		"sector" => [Sector, 1],
		"set3D2" => [nil, 3, -1, false]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("PieChart.create", width, height, bgColor, edgeColor, raisedEffect))
	end
	def set3D(depth = -1, angle = -1, shadowMode = false)
		_r(encodeIfArray("PieChart.set3D", depth), @this, depth, angle, shadowMode)
	end
	def getSector(sectorNo)
		return sector(sectorNo)
	end
end

#
# bindings to axis.h
#

class Mark < TextBox
	def setMarkColor(lineColor, textColor = -1, tickColor = -1)
		_r("Mark.setMarkColor", @this, lineColor, textColor, tickColor)
	end
end

class Axis < AutoMethod
	DefaultArgs = {
		"setLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"setTitle" => [TextBox, 4, "", 8, TextColor],
		"setTitlePos" => [nil, 2, 3],
		"setColors" => [nil, 4, TextColor, -1, -1],
		"setTickWidth" => [nil, 2, -1],
		"setTickColor" => [nil, 2, -1],
		"setMargin" => [nil, 2, 0],
		"setAutoScale" => [nil, 3, 0.1, 0.1, 0.8],
		"setTickDensity" => [nil, 2, -1],
		"setReverse" => [nil, 1, 1],
		"setLabels2" => [TextBox, 2, ""],
		"makeLabelTable" => [CDMLTable, 0],
		"getLabelTable" => [CDMLTable, 0],
		"setLinearScale3" => [nil, 1, ""],
		"setDateScale3" => [nil, 1, ""],
		"addMark" => [Mark, 5, "", "", 8],
		"getAxisImageMap" => [nil, 7, "", "", 0, 0],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0],
		"setMultiFormat2" => [nil, 4, 1, 1],
		"setLabelStep" => [nil, 4, 0, 0, -0x7fffffff],
		"setFormatCondition" => [nil, 2, 0]
		}
	def setTickLength(majorTickLen, minorTickLen = nil)
		if not minorTickLen
			_r("Axis.setTickLength", @this, majorTickLen)
		else
			setTickLength2(majorTickLen, minorTickLen)
		end
	end
	def setTopMargin(topMargin)
		setMargin(topMargin)
	end
	def setLabels(labels, formatString = nil)
		if not formatString
			return TextBox.new(_r("Axis.setLabels", @this, labels))
		else
			return setLabels2(labels, formatString)
		end
	end
	def setLinearScale(lowerLimit = nil, upperLimit = nil, majorTickInc = 0, minorTickInc = 0)
		if not lowerLimit
			setLinearScale3()
		elsif not upperLimit
			setLinearScale3(lowerLimit)
		elsif majorTickInc.class == Array
			setLinearScale2(lowerLimit, upperLimit, majorTickInc)
		else
			_r("Axis.setLinearScale", @this, lowerLimit, upperLimit, majorTickInc, minorTickInc)
		end
	end
	def setLogScale(lowerLimit = nil, upperLimit = nil, majorTickInc = 0, minorTickInc = 0)
		if not lowerLimit
			setLogScale3()
		elsif not upperLimit
			setLogScale3(lowerLimit)
		elsif majorTickInc.class == Array
			setLogScale2(lowerLimit, upperLimit, majorTickInc)
		else
			_r("Axis.setLogScale", @this, lowerLimit, upperLimit, majorTickInc, minorTickInc)
		end
	end
	def setLogScale3(formatString = "")
		_r("Axis.setLogScale3", @this, formatString)
	end
	def setDateScale(lowerLimit = nil, upperLimit = nil, majorTickInc = 0, minorTickInc = 0)
		if not lowerLimit
			setDateScale3()
		elsif not upperLimit
			setDateScale3(lowerLimit)
		elsif majorTickInc.class == Array
			setDateScale2(lowerLimit, upperLimit, majorTickInc)
		else
			_r("Axis.setDateScale", @this, lowerLimit, upperLimit, majorTickInc, minorTickInc)
		end
	end
	def syncAxis(axis, slope = 1, intercept = 0)
		_r("Axis.syncAxis", @this, axis.this, slope, intercept)
	end
	def copyAxis(axis)
		_r("Axis.copyAxis", @this, axis.this)
	end
	def setMultiFormat(filter1, format1, filter2 = 1, format2 = nil, labelSpan = 1, promoteFirst = 1)
		if not format2
			setMultiFormat2(filter1, format1, filter2, 1)
		else
			_r("Axis.setMultiFormat", @this, filter1, format1, filter2, format2, labelSpan, promoteFirst)
		end
	end
end

class ColorAxis < Axis
	DefaultArgs = {
		"setColorGradient" => [nil, 4, 1, nil, -1, -1],
		"setCompactAxis" => [nil, 1, 1],
		"setAxisBorder" => [nil, 2, 0],
		"setBoundingBox" => [nil, 3, Transparent, 0],
		"setRoundedCorners" => [nil, 4, 10, -1, -1, -1]
	}
end
	
class AngularAxis < AutoMethod
	DefaultArgs = {
		"setLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"setReverse" => [nil, 1, 1],
		"setLabels2" => [TextBox, 2, ""],
		"addZone2" => [nil, 4, -1],
		"getAxisImageMap" => [nil, 7, "", "", 0, 0],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0]
		}
	def setLabels(labels, formatString = nil)
		if not formatString
			return TextBox.new(_r("AngularAxis.setLabels", @this, labels))
		else
			return setLabels2(labels, formatString)
		end
	end
	def setLinearScale(lowerLimit, upperLimit, majorTickInc = 0, minorTickInc = 0)
		if majorTickInc.class == Array
			setLinearScale2(lowerLimit, upperLimit, majorTickInc)
		else
			_r("AngularAxis.setLinearScale", @this, lowerLimit, upperLimit, majorTickInc, minorTickInc)
		end
	end
	def addZone(startValue, endValue, startRadius, endRadius = -1, fillColor = nil, edgeColor = -1)
		if not fillColor
			addZone2(startValue, endValue, startRadius, endRadius)
		else
			_r("AngularAxis.addZone", @this, startValue, endValue, startRadius, endRadius, fillColor, edgeColor)
		end
	end
end

#
# bindings to layer.h
#

class DataSet < AutoMethod
	DefaultArgs = {
		"setDataColor" => [nil, 4, -1, -1, -1, -1],
		"setUseYAxis2" => [nil, 1, 1],
		"setDataLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"setDataSymbol4" => [nil, 4, 11, -1, -1]
		}
	def setDataSymbol(symbol, size = nil, fillColor = -1, edgeColor = -1, lineWidth = 1)
		if symbol.class == Array
			if not size 
				size = 11
			end
			return setDataSymbol4(symbol, size, fillColor, edgeColor)
		end
		if not size
			begin
				symbol = Integer(symbol)
				size = 5
			rescue
				return setDataSymbol2(symbol)
			end
		end
		_r("DataSet.setDataSymbol", @this, symbol, size, fillColor, edgeColor, lineWidth)
	end
	def setDataSymbol2(image)
		if image.respond_to?("this")
			setDataSymbol3(image)
		else
			_r("DataSet.setDataSymbol2", @this, image)
		end
	end
	def setDataSymbol3(image)
		_r("DataSet.setDataSymbol3", @this, image.this)
	end
	def setUseYAxis(yAxis)
		_r("DataSet.setUseYAxis", @this, yAxis.this)
	end
end

class Layer < AutoMethod
	DefaultArgs = {
		"setBorderColor" => [nil, 2, 0],
		"set3D" => [nil, 2, -1, 0],
		"addDataSet" => [DataSet, 3, -1, ""],
		"addDataGroup" => [nil, 1, ""],
		"getDataSet" => [DataSet, 1],
		"setUseYAxis2" => [nil, 1, 1],
		"setLegendOrder" => [nil, 2, -1],
		"setDataLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"setAggregateLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"addCustomDataLabel" => [TextBox, 7, "", 8, TextColor, 0],
		"addCustomAggregateLabel" => [TextBox, 6, "", 8, TextColor, 0],
		"addCustomGroupLabel" => [TextBox, 7, "", 8, TextColor, 0],
		"getImageCoor2" => [nil, 3, 0, 0],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0],
		"setHTMLImageMap" => [nil, 3, "", ""]
		}
	def getImageCoor(dataSet, dataItem = nil, offsetX = 0, offsetY = 0)
		if not dataItem
			return getImageCoor2(dataItem)
		else
			return _r("Layer.getImageCoor", @this, dataSet, dataItem, offsetX, offsetY)
		end
	end
	def setXData(xData, dummy = nil)
		if dummy
			setXData2(xData, dummy)
		else
			_r("Layer.setXData", @this, xData)
		end
	end
	def getYCoor(value, yAxis = 1)
		if yAxis.respond_to?("this")
			return _r("Layer.getYCoor2", @this, value, yAxis.this)
		else
			return _r("Layer.getYCoor", @this, value, yAxis)
		end
	end
	def setUseYAxis(yAxis)
		_r("Layer.setUseYAxis", @this, yAxis.this)
	end
	def yZoneColor(threshold, belowColor, aboveColor, yAxis = 1)
		if yAxis.respond_to?("this")
			return _r("Layer.yZoneColor2", @this, threshold, belowColor, aboveColor, yAxis.this)
		else
			return _r("Layer.yZoneColor", @this, threshold, belowColor, aboveColor, yAxis)
		end
	end
	def alignLayer(layer, dataSet)
		_r("Layer.alignLayer", @this, layer.this, dataSet)
	end
	def moveFront(layer = nil)
		_r("Layer.moveFront", @this, decodePtr(layer))
	end
	def moveBack(layer = nil)
		_r("Layer.moveFront", @this, decodePtr(layer))
	end
end

#
# bindings to barlayer.h
#

class BarLayer < Layer
	DefaultArgs = {
		"setBarGap" => [nil, 2, 0.2],
		"setBarWidth" => [nil, 2, -1],
		"setIconSize" => [nil, 2, -1],
		"setOverlapRatio" => [nil, 2, 1],
		"setBarShape2" => [nil, 3, -1, -1]
	}
	def setBarShape(shape, dataGroup = -1, dataItem = -1)
		_r(encodeIfArray("BarLayer.setBarShape", shape), @this, shape, dataGroup, dataItem)
	end
end

#
# bindings to linelayer.h
#
class LineLayer < Layer
	DefaultArgs = {
		"setGapColor" => [nil, 2, -1],
		"setSymbolScale" => [nil, 4, PixelScale, nil, PixelScale],
		"getLine" => [nil, 1, 0]
	}
end
	
class ScatterLayer < LineLayer
end

class InterLineLayer < LineLayer
	def setGapColor(gapColor12, gapColor21 = -1)
		_r("InterLineLayer.setGapColor", @this, gapColor12, gapColor21)
	end
end
	
class SplineLayer < LineLayer
end
		
class StepLineLayer < LineLayer
end
		
#
# bindings to arealayer.h
#

class AreaLayer < Layer
end

#
# bindings to trendlayer.h
#

class TrendLayer < Layer
	DefaultArgs = {
		"addConfidenceBand" => [nil, 7, Transparent, 1, -1, -1, -1],
		"addPredictionBand" => [nil, 7, Transparent, 1, -1, -1, -1]
	}
end
			
#
# bindings to hloclayer.h
#

class BaseBoxLayer < Layer
end
	
class HLOCLayer < BaseBoxLayer
	def setColorMethod(colorMethod, riseColor, fallColor = -1, leadValue = -C17E308)
		_r("HLOCLayer.setColorMethod", @this, colorMethod, riseColor, fallColor, leadValue)
	end
end
			
class CandleStickLayer < BaseBoxLayer
end

class BoxWhiskerLayer < BaseBoxLayer
	DefaultArgs = {
		"setBoxColors" => [nil, 2, nil],
		"addPredictionBand" => [nil, 7, Transparent, 1, -1, -1, -1]
	}
end

#
# bindings to vectorlayer.h
#

class VectorLayer < Layer
	DefaultArgs = {
		"setVector" => [nil, 3, PixelScale],
		"setIconSize" => [nil, 2, 0],
		"setVectorMargin" => [nil, 2, NoValue]
	}	
	def setArrowHead(width, height = 0)
		if width.class == Array
			setArrowHead2(width)
		else
			_r("VectorLayer.setArrowHead", @this, width, height)
		end
	end
end

#
# bindings to contourlayer.h
#
class ContourLayer < Layer
	DefaultArgs = {
		"setContourColor" => [nil, 2, -1],
		"setContourWidth" => [nil, 2, -1],
		"setColorAxis" => [ColorAxis, 5],
		"colorAxis" => [ColorAxis, 0]
	}
end	

#
# bindings to xychart.h
#

class PlotArea < AutoMethod
	DefaultArgs = {
		"setBackground" => [nil, 3, -1, -1],
		"setBackground2" => [nil, 2, Center],
		"set4QBgColor" => [nil, 5, -1],
		"setAltBgColor" => [nil, 4, -1],
		"setGridColor" => [nil, 4, Transparent, -1, -1],
		"setGridWidth" => [nil, 4, -1, -1, -1]
	}
	def setGridAxis(xAxis, yAxis)
		_r("PlotArea.setGridAxis", @this, decodePtr(xAxis), decodePtr(yAxis))
	end
	def moveGridBefore(layer = nil)
		_r("PlotArea.moveGridBefore", @this, decodePtr(layer))
	end
end

class XYChart < BaseChart
	DefaultArgs = {
		"yAxis" => [Axis, 0],	
		"yAxis2" => [Axis, 0],	
		"syncYAxis" => [Axis, 2, 1, 0],	
		"setYAxisOnRight" => [nil, 1, 1],
		"setXAxisOnTop" => [nil, 1, 1],
		"xAxis" => [Axis, 0],	
		"xAxis2" => [Axis, 0],	
		"addAxis" => [Axis, 2],
		"swapXY" => [nil, 1, 1],
		"setPlotArea" => [PlotArea, 9, Transparent, -1, -1, 0xc0c0c0, Transparent],
		"getPlotArea" => [PlotArea, 0],
		"setClipping" => [nil, 1, 0],
		"addBarLayer2" => [BarLayer, 2, Side, 0],
		"addBarLayer3" => [BarLayer, 4, nil, nil, 0],
		"addLineLayer2" => [LineLayer, 2, Overlay, 0],
		"addAreaLayer2" => [AreaLayer, 2, Stack, 0],
		"addHLOCLayer2" => [HLOCLayer, 0],
		"addScatterLayer" => [ScatterLayer, 7, "", SquareSymbol, 5, -1, -1],
		"addCandleStickLayer" => [CandleStickLayer, 7, 0xffffff, 0x0, LineColor],
		"addBoxWhiskerLayer" => [BoxWhiskerLayer, 8, nil, nil, nil, -1, LineColor, LineColor],
		"addBoxWhiskerLayer2" => [BoxWhiskerLayer, 8, nil, nil, nil, nil, 0.5, nil],
		"addBoxLayer" => [BoxWhiskerLayer, 4, -1, ""],
		"addTrendLayer" => [TrendLayer, 4, -1, "", 0],
		"addTrendLayer2" => [TrendLayer, 5, -1, "", 0],
		"addSplineLayer" => [SplineLayer, 3, nil, -1, ""],
		"addStepLineLayer" => [StepLineLayer, 3, nil, -1, ""],
		"addInterLineLayer" => [InterLineLayer, 4, -1],
		"addVectorLayer" => [VectorLayer, 7, PixelScale, -1, ""],
		"addContourLayer" => [ContourLayer, 3],
		"setAxisAtOrigin" => [nil, 2, XYAxisAtOrigin, 0],
		"setTrimData" => [nil, 2, 0x7fffffff],
		"packPlotArea" => [nil, 6, 0, 0]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("XYChart.create", width, height, bgColor, edgeColor, raisedEffect))
	end
	def addBarLayer(data = nil, color = -1, name = "", depth = 0)
		if data
			return BarLayer.new(_r("XYChart.addBarLayer", @this, data, color, name, depth))
		else
			return addBarLayer2()
		end
	end
	def addLineLayer(data = nil, color = -1, name = "", depth = 0)
		if data
			return LineLayer.new(_r("XYChart.addLineLayer", @this, data, color, name, depth))
		else
			return addLineLayer2()
		end
	end
	def addAreaLayer(data = nil, color = -1, name = "", depth = 0)
		if data
			return AreaLayer.new(_r("XYChart.addAreaLayer", @this, data, color, name, depth))
		else
			return addAreaLayer2()
		end
	end
	def addHLOCLayer(highData = nil, lowData = nil, openData = nil, closeData = nil, 
		upColor = -1, downColor = -1, colorMode = -1, leadValue = -C17E308)
		if highData
			return HLOCLayer.new(_r("XYChart.addHLOCLayer3", @this, highData, lowData, openData, closeData, upColor, downColor, colorMode, leadValue))
		else
			return addHLOCLayer2()
		end
	end
	def addHLOCLayer3(highData = nil, lowData = nil, openData = nil, closeData = nil, 
		upColor = -1, downColor = -1, colorMode = -1, leadValue = -C17E308)
		return addHLOCLayer(highData, lowData, openData, closeData, upColor, downColor, colorMode, leadValue)
	end
	def getYCoor(value, yAxis = nil)
		return _r("XYChart.getYCoor", @this, value, decodePtr(yAxis))
	end
	def yZoneColor(threshold, belowColor, aboveColor, yAxis = nil)
		return _r("XYChart.yZoneColor", @this, threshold, belowColor, aboveColor, decodePtr(yAxis))
	end
end

#
# bindings to surfacechart.h
#
class SurfaceChart < BaseChart
	DefaultArgs = {
		"setViewAngle" => [nil, 3, 0, 0],	
		"setInterpolation" => [nil, 3, -1, 1],	
		"setShadingMode" => [nil, 2, 1],	
		"setSurfaceAxisGrid" => [nil, 4, -1, -1, -1],
		"setSurfaceDataGrid" => [nil, 2, -1],
		"setContourColor" => [nil, 2, -1],
		"xAxis" => [Axis, 0],	
		"yAxis" => [Axis, 0],
		"zAxis" => [Axis, 0],	
		"setColorAxis" => [ColorAxis, 5],	
		"colorAxis" => [ColorAxis, 0],
		"setWallColor" => [nil, 4, -1, -1, -1],
		"setWallThickness" => [nil, 3, -1, -1],
		"setWallGrid" => [nil, 6, -1, -1, -1, -1, -1]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("SurfaceChart.create", width, height, bgColor, edgeColor, raisedEffect))
	end
end

#
# bindings to polarchart.h
#

class PolarLayer < AutoMethod
	DefaultArgs = {
		"setData" => [nil, 3, -1, ""],
		"setSymbolScale" => [nil, 2, PixelScale],
		"getImageCoor" => [nil, 3, 0, 0],
		"getHTMLImageMap" => [nil, 5, "", "", 0, 0],
		"setDataLabelStyle" => [TextBox, 4, "", 8, TextColor, 0],
		"addCustomDataLabel" => [TextBox, 6, "", 8, TextColor, 0],
		"setDataSymbol4" => [nil, 4, 11, -1, -1],
		"setHTMLImageMap" => [nil, 3, "", ""]
	}
	def setDataSymbol(symbol, size = nil, fillColor = -1, edgeColor = -1, lineWidth = 1)
		if symbol.class == Array
			if not size
				size = 11
			end
			return setDataSymbol4(symbol, size, fillColor, edgeColor)
		end
		if not size
			begin
				symbol = symbol.to_i
				size = 7
			rescue
				return setDataSymbol2(symbol)
			end
		end
		_r("PolarLayer.setDataSymbol", @this, symbol, size, fillColor, edgeColor, lineWidth)
	end
	def setDataSymbol2(image)
		if image.respond_to?("this")
			setDataSymbol3(image)
		else
			_r("PolarLayer.setDataSymbol2", @this, image)
		end
	end
	def setDataSymbol3(image)
		_r("PolarLayer.setDataSymbol3", @this, image.this)
	end
end
	
class PolarAreaLayer < PolarLayer
end

class PolarLineLayer < PolarLayer
	DefaultArgs = {
		"setGapColor" => [nil, 2, -1]
	}
end

class PolarSplineLineLayer < PolarLineLayer
end

class PolarSplineAreaLayer < PolarLineLayer
end

class PolarVectorLayer < PolarLayer
	DefaultArgs = {
		"setVector" => [nil, 3, PixelScale],
		"setIconSize" => [nil, 2, 0],
		"setVectorMargin" => [nil, 2, NoValue]
	}	
	def setArrowHead(width, height = 0)
		if width.class == Array
			setArrowHead2(width)
		else
			_r("PolarVectorLayer.setArrowHead", @this, width, height)
		end
	end
end

class PolarChart < BaseChart
	DefaultArgs = {
		"setPlotArea" => [nil, 6, Transparent, Transparent, 1],	
		"setPlotAreaBg" => [nil, 3, -1, 1],	
		"setGridColor" => [nil, 4, LineColor, 1, LineColor, 1],
		"setGridStyle" => [nil, 2, 1],
		"setStartAngle" => [nil, 2, 1],
		"angularAxis" => [AngularAxis, 0],
		"radialAxis" => [Axis, 0],	
		"addAreaLayer" => [PolarAreaLayer, 3, -1, ""],
		"addLineLayer" => [PolarLineLayer, 3, -1, ""],
		"addSplineLineLayer" => [PolarSplineLineLayer, 3, -1, ""],
		"addSplineAreaLayer" => [PolarSplineAreaLayer, 3, -1, ""],
		"addVectorLayer" => [PolarVectorLayer, 7, PixelScale, -1, ""]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("PolarChart.create", width, height, bgColor, edgeColor, raisedEffect))
	end
end

#
# bindings to pyramidchart.h
#

class PyramidLayer < AutoMethod
	DefaultArgs = {
		"setCenterLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setRightLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setLeftLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setJoinLine" => [nil, 2, -1],
		"setJoinLineGap" => [nil, 3, -0x7fffffff, -0x7fffffff],
		"setLayerBorder" => [nil, 2, -1]
	}	
end
	
class PyramidChart < BaseChart
	DefaultArgs = {
		"setFunnelSize" => [nil, 6, 0.2, 0.3],
		"setData" => [nil, 2, nil],
		"setCenterLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setRightLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setLeftLabel" => [TextBox, 4, "{skip}", "{skip}", -1, -1],
		"setViewAngle" => [nil, 3, 0, 0],
		"setLighting" => [nil, 4, 0.5, 0.5, 1, 8],
		"setJoinLine" => [nil, 2, -1],
		"setJoinLineGap" => [nil, 3, -0x7fffffff, -0x7fffffff],
		"setLayerBorder" => [nil, 2, -1],
		"getLayer" => [PyramidLayer, 1]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("PyramidChart.create", width, height, bgColor, edgeColor, raisedEffect))
	end
end

#
# bindings to meters.h
#

class MeterPointer < AutoMethod
	DefaultArgs = {
		"setColor" => [nil, 2, -1],
		"setShape2" => [nil, 3, NoValue, NoValue]
	}
	def setShape(pointerType, lengthRatio = NoValue, widthRatio = NoValue)
		_r(encodeIfArray("MeterPointer.setShape", pointerType), @this, pointerType, lengthRatio, widthRatio)
	end
end
	
class BaseMeter < BaseChart
	DefaultArgs = {
		"addPointer" => [MeterPointer, 3, LineColor, -1],
		"setScale3" => [nil, 4, ""],
		"setLabelStyle" => [TextBox, 4, "bold", -1, TextColor, 0],
		"setLabelPos" => [nil, 2, 0],
		"setTickLength" => [nil, 3, -0x7fffffff, -0x7fffffff],
		"setLineWidth" => [nil, 4, 1, 1, 1],
		"setMeterColors" => [nil, 3, -1, -1]
	}
	def setScale(lowerLimit, upperLimit, majorTickInc = 0, minorTickInc = 0, microTickInc = 0)
		if majorTickInc.class == Array
			if minorTickInc != 0
				setScale3(lowerLimit, upperLimit, majorTickInc, minorTickInc)
			else
				setScale2(lowerLimit, upperLimit, majorTickInc)
			end
		else
			_r("BaseMeter.setScale", @this, lowerLimit, upperLimit, majorTickInc, minorTickInc, microTickInc)
		end
	end
end

class AngularMeter < BaseMeter
	DefaultArgs = {
		"addRing" => [nil, 4, -1],
		"addRingSector" => [nil, 6, -1],
		"setCap" => [nil, 3, LineColor],
		"addZone2" => [nil, 4, -1]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("AngularMeter.create", width, height, bgColor, edgeColor, raisedEffect))
	end
	def addZone(startValue, endValue, startRadius, endRadius = -1, fillColor = nil, edgeColor = -1)
		if not fillColor
			addZone2(startValue, endValue, startRadius, endRadius)
		else
			_r("AngularMeter.addZone", @this, startValue, endValue, startRadius, endRadius, fillColor, edgeColor)
		end
	end
end

class LinearMeter < BaseMeter
	DefaultArgs = {
		"setMeter" => [nil, 6, Left, false],
		"setRail" => [nil, 3, 2, 6],
		"addZone" => [TextBox, 4, ""]
	}
	def initialize(width, height, bgColor = BackgroundColor, edgeColor = Transparent, raisedEffect = 0)
		super(_r("LinearMeter.create", width, height, bgColor, edgeColor, raisedEffect))
	end
end

#
# bindings to chartdir.h
#

def getCopyright()
	return _r("getCopyright")
end

def getVersion()
	return _r("getVersion")
end

def getDescription()
	return _r("getDescription")
end

def getBootLog()
	return _r("getBootLog")
end

def libgTTFTest(font = "", fontIndex = 0, fontHeight = 8, fontWidth = 8, angle = 0)
	return _r("testFont", font, fontIndex, fontHeight, fontWidth, angle)
end

def testFont(font = "", fontIndex = 0, fontHeight = 8, fontWidth = 8, angle = 0)
	return _r("testFont", font, fontIndex, fontHeight, fontWidth, angle)
end

def setLicenseCode(licCode)
    return _r("setLicenseCode", licCode)
end

def chartTime(y, m = nil, d = 1, h = 0, n = 0, s = 0)
	if not m
		return chartTime2(y)
	else
		return _r("chartTime", y, m, d, h, n, s)
	end
end

def chartTime2(t)
	return _r("chartTime2", t)
end

def getChartYMD(t)
	return _r("getChartYMD", t)
end

def getChartWeekDay(t)
	return (t.to_i / 86400 + 1) % 7
end

#
# bindings to rantable.h
#

class RanTable < AutoMethod
	DefaultArgs = {
		"setCol2" => [nil, 6, -C17E308, C17E308],
		"setDateCol" => [nil, 4, false],
		"setHLOCCols" => [nil, 6, 0, C17E308]
		}
	def initialize(seed, noOfCols, noOfRows)
		@this = _r("RanTable.create", seed, noOfCols, noOfRows)
		destructor("RanTable.destroy", @this)
	end
	def setCol(colNo, minValue, maxValue, p4 = nil, p5 = -C17E308, p6 = C17E308)
		if not p4
			_r("RanTable.setCol", @this, colNo, minValue, maxValue)
		else
			setCol2(colNo, minValue, maxValue, p4, p5, p6)
		end
	end
end
	
class FinanceSimulator < AutoMethod
	def initialize(seed, startTime, endTime, resolution)
		if seed.is_a?(Integer)
			@this = _r("FinanceSimulator.create", seed, startTime, endTime, resolution)
		else
			@this = _r("FinanceSimulator.create2", seed, startTime, endTime, resolution)
		end
		destructor("FinanceSimulator.destroy", @this)
	end
end

#
# bindings to datafilter.h
#

class ArrayMath < AutoMethod
	DefaultArgs = {
		"shift" => [nil, 2, 1, NoValue],
		"delta" => [nil, 1, 1],
		"rate" => [nil, 1, 1],
		"trim" => [nil, 2, 0, -1],
		"insert" => [nil, 2, -1],
		"insert2" => [nil, 3, -1],
		"selectGTZ" => [nil, 2, nil, 0],
		"selectGEZ" => [nil, 2, nil, 0],
		"selectLTZ" => [nil, 2, nil, 0],
		"selectLEZ" => [nil, 2, nil, 0],
		"selectEQZ" => [nil, 2, nil, 0],
		"selectNEZ" => [nil, 2, nil, 0],
		"selectStartOfHour" => [nil, 2, 1, 300],
		"selectStartOfDay" => [nil, 2, 1, 3 * 3600],
		"selectStartOfWeek" => [nil, 2, 1, 2 * 86400],
		"selectStartOfMonth" => [nil, 2, 1, 5 * 86400],
		"selectStartOfYear" => [nil, 2, 1, 60 * 86400],
		"movCorr" => [nil, 2, nil],
		"lowess" => [nil, 2, 0.25, 0],
		"lowess2" => [nil, 3, 0.25, 0],
		"selectRegularSpacing" => [nil, 3, 0, 0],
		"aggregate" => [nil, 3, 50]
		}
	def initialize(a)
		destructor("ArrayMath.destroy", @this = _r("ArrayMath.create", a))
	end
	def method_missing(name, *args)
		ret = super
		return (ret == @this) ? self : ret
	end
	def binOp(op, b)
		if b.class == Array
			_r("ArrayMath." + op, @this, b)
		else
			send(op + "2", b)
		end
		return self
	end
	def add(b)
		return binOp("add", b)
	end
	def sub(b)
		return binOp("sub", b)
	end
	def mul(b)
		return binOp("mul", b)
	end
	def div(b)
		return binOp("div", b)
	end
end

#
# Utility functions
#

# Normalize the path and remove trailing slash
def normalizePath(path)
	return path.sub('\\', '/').chomp('/')
end
	
# Create a unique temporary file name and automatically removes old temporary files 
def tmpFile2(path, lifeTime, ext)

	# avoid checking for old files too frequently
	if lifeTime >= 0
		currentTime = Time.new
		timeStampFile = path + "/__cd__lastcheck.tmp"
		begin
			lastCheck = (currentTime - File.mtime(timeStampFile)).abs
			if lastCheck < lifeTime and lastCheck < 10
				lifeTime = -1
			else
				File.utime(currentTime, currentTime, timeStampFile)
			end
		rescue
			begin
				if not File.exists?(timeStampFile)
					f = File.open(timeStampFile, "wb")
					f.write(currentTime.to_s)
					f.close()
				end
			rescue
			end
		end
	end
	
	# remove old temporary files
	if lifeTime >= 0
		begin
			garbage = []
			Dir.foreach(path) do |p|
				if p[0..3] != "cd__"
					next
				end
				filename = path + "/" + p
				if (currentTime - File.ctime(filename)).abs > lifeTime
					garbage.push(filename)
				end
			end
			garbage.each { |p| File.delete(p) }
		rescue
			#make the directory in case it does not exist
			fields = path.split('/')
			if fields[0] == ''
				fields[0..1] = '/' + fields[1]
			end
			fields.each_index do |i|
				begin
					Dir.mkdir(fields[0..i].join('/'), 0777)
				rescue
				end
			end
		end
	end
				
	#create unique file name
	seqNo = 0
	while seqNo < 100
		if ENV.has_key?("UNIQUE_ID")
			filename = sprintf("cd__%s%s_%s%s", ENV["UNIQUE_ID"], Time.new.to_i, seqNo, ext)
		else
			filename = sprintf("cd__%s%s%s%s_%s%s", ENV["REMOTE_ADDR"], ENV["REMOTE_PORT"], 
				Process.pid, Time.new.to_i, seqNo, ext)
		end
		if not File.exists?(path + "/" + filename)
			break
		end
		seqNo = seqNo + 1
	end
	
	return filename
end

#
# WebChartViewer implementation
#

MouseUsageDefault = 0
MouseUsageScroll = 2
MouseUsageZoomIn = 3
MouseUsageZoomOut = 4
	
DirectionHorizontal = 0
DirectionVertical = 1
DirectionHorizontalVertical = 2

class WebChartViewer < AutoMethod

	C_s = "_JsChartViewerState"
	C_p = "cdPartialUpdate"
	C_d = "cdDirectStream"

	def initialize(request, id)
		this = @this = _r("WebChartViewer.create")
		destructor("WebChartViewer.destroy", this)
		putAttrS(":id", id)
		@request = request
		if request and id and request.parameters.has_key?(id + C_s)
			putAttrS(":state", request.parameters[id + C_s])
		end
	end
			
	def getRequest()
		return @request
	end
	def getId()
		return getAttrS(":id")
	end
	
	def setImageUrl(url)
		putAttrS(":url", url)
	end
	def getImageUrl()
		return getAttrS(":url")
	end
	
	def setImageMap(imageMap)
		putAttrS(":map", imageMap)
	end
	def getImageMap()
		return getAttrS(":map")
	end
		
	def setChartMetrics(metrics)
		putAttrS(":metrics", metrics)
	end
	def getChartMetrics()
		return getAttrS(":metrics")
	end
		
	def makeDelayedMap(imageMap, compress = false)
		if compress
			encoding = @request.env["HTTP_ACCEPT_ENCODING"]
			if encoding and not encoding.index("gzip")
				compress = false
			end
		end

		b = "<body><!--CD_MAP #{imageMap} CD_MAP--></body>"
		ext = ".map"
		if compress
			b = _r("WebChartViewer.compressMap", @this, b, 4)
			if b and b.length > 2 and b[0..1] == "\x1f\x8b"
				ext = ".map.gz"
			end
		end

		return b
	end
		
	def renderHTML(extraAttrs = nil)
		return if not @request
		path, query = @request.request_uri.split('?', 2)
		return _r("WebChartViewer.renderHTML", @this, path, query, extraAttrs)	
	end
	def partialUpdateChart(msg = nil, timeout = 0)
		return _r("WebChartViewer.partialUpdateChart", @this, msg, timeout)
	end
		
	def isPartialUpdateRequest()
		return(@request and @request.parameters.has_key?(C_p))
	end
	def isFullUpdateRequest()
		return false if isPartialUpdateRequest()
		if @request
			@request.parameters().each_key { |k| return true if k[-C_s.length .. -1] == C_s }
		end
		return false
	end
	def isStreamRequest()
		return(@request and @request.parameters.has_key?(C_d))
	end
	def isViewPortChangedEvent()
		return getAttrF(25, 0) != 0 
	end
	def getSenderClientId()
		if isPartialUpdateRequest()
			return @request.parameters[C_p]
		elsif isStreamRequest()
			return @request.parameters[C_d].value
		else
			return nil
		end
	end

	def getAttrS(attr, defaultValue = "")
		return _r("WebChartViewer.getAttrS", @this, attr.to_s, defaultValue.to_s)
	end
	def getAttrF(attr, defaultValue = 0)
		return _r("WebChartViewer.getAttrF", @this, attr.to_s, defaultValue.to_f)
	end
	def putAttrF(attr, value)
		_r("WebChartViewer.putAttrF", @this, attr.to_s, value.to_f)
	end
	def putAttrS(attr, value)
		_r("WebChartViewer.putAttrS", @this, attr.to_s, value.to_s)
	end

	def getViewPortLeft()
		return getAttrF(4, 0)
	end
	def setViewPortLeft(left)
		putAttrF(4, left)
	end

	def getViewPortTop()
		return getAttrF(5, 0)
	end
	def setViewPortTop(top)
		putAttrF(5, top)
	end

	def getViewPortWidth()
		return getAttrF(6, 1)
	end
	def setViewPortWidth(width)
		putAttrF(6, width)
	end

	def getViewPortHeight()
		return getAttrF(7, 1)
	end
	def setViewPortHeight(height)
		putAttrF(7, height)
	end

	def getSelectionBorderWidth()
		return getAttrF(8, 2).to_i
	end
	def setSelectionBorderWidth(lineWidth)
		putAttrF(8, lineWidth)
	end

	def getSelectionBorderColor()
		return getAttrS(9, "Black")
	end
	def setSelectionBorderColor(color)
		putAttrS(9, color)
	end

	def getMouseUsage()
		return getAttrF(10, MouseUsageDefault).to_i
	end
	def setMouseUsage(usage)
		putAttrF(10, usage)
	end

	def getScrollDirection()
		return getAttrF(11, DirectionHorizontal).to_i
	end
	def setScrollDirection(direction)
		putAttrF(11, direction)
	end

	def getZoomDirection()
		return getAttrF(12, DirectionHorizontal).to_i
	end
	def setZoomDirection(direction)
		putAttrF(12, direction)
	end

	def getZoomInRatio()
		return getAttrF(13, 2)
	end
	def setZoomInRatio(ratio)
		putAttrF(13, ratio) if ratio > 0
	end

	def getZoomOutRatio()
		return getAttrF(14, 0.5)
	end
	def setZoomOutRatio(ratio)
		putAttrF(14, ratio) if ratio > 0
	end

	def getZoomInWidthLimit()
		return getAttrF(15, 0.01)
	end
	def setZoomInWidthLimit(limit)
		putAttrF(15, limit)
	end

	def getZoomOutWidthLimit()
		return getAttrF(16, 1)
	end
	def setZoomOutWidthLimit(limit)
		putAttrF(16, limit)
	end

	def getZoomInHeightLimit()
		return getAttrF(17, 0.01)
	end
	def setZoomInHeightLimit(limit)
		putAttrF(17, limit)
	end

	def getZoomOutHeightLimit()
		return getAttrF(18, 1)
	end
	def setZoomOutHeightLimit(limit)
		putAttrF(18, limit)
	end
		
	def getMinimumDrag()
		return getAttrF(19, 5).to_i
	end
	def setMinimumDrag(offset)
		putAttrF(19, offset)
	end

	def getZoomInCursor()
		return getAttrS(20, "")
	end
	def setZoomInCursor(cursor)
		putAttrS(20, cursor)
	end

	def getZoomOutCursor()
		return getAttrS(21, "")
	end
	def setZoomOutCursor(cursor)
		putAttrS(21, cursor)
	end

	def getScrollCursor()
		return getAttrS(22, "")
	end
	def setScrollCursor(cursor)
		putAttrS(22, cursor)
	end

	def getNoZoomCursor()
		return getAttrS(26, "")
	end
	def setNoZoomCursor(cursor)
		putAttrS(26, cursor)
	end

	def getCustomAttr(key)
		return getAttrS(key, "")
	end
	def setCustomAttr(key, value)
		putAttrS(key, value)
	end
end

AllClasses = {
AngularAxis=>nil,
AngularMeter=>nil,
AreaLayer=>nil,
ArrayMath=>nil,
Axis=>nil,
CDMLTable=>nil,
ColorAxis=>nil,
ContourLayer=>nil,
BarLayer=>nil,
BaseBoxLayer=>nil,
BaseChart=>nil,
BaseMeter=>nil,
Box=>nil,
BoxWhiskerLayer=>nil,
CandleStickLayer=>nil,
ContourLayer=>nil,
DataSet=>nil,
DrawArea=>nil,
FinanceSimulator=>nil,
HLOCLayer=>nil,
InterLineLayer=>nil,
Layer=>nil,
LegendBox=>nil,
Line=>nil,
LineLayer=>nil,
LinearMeter=>nil,
Mark=>nil,
MeterPointer=>nil,
MultiChart=>nil,
PieChart=>nil,
PlotArea=>nil,
PolarAreaLayer=>nil,
PolarChart=>nil,
PolarLayer=>nil,
PolarLineLayer=>nil,
PolarSplineAreaLayer=>nil,
PolarSplineLineLayer=>nil,
PolarVectorLayer=>nil,
PyramidChart=>nil,
PyramidLayer=>nil,
RanTable=>nil,
ScatterLayer=>nil,
Sector=>nil,
SplineLayer=>nil,
StepLineLayer=>nil,
SurfaceChart=>nil,
TTFText=>nil,
TextBox=>nil,
TrendLayer=>nil,
VectorLayer=>nil,
XYChart=>nil,
WebChartViewer=>nil
}

module InteractiveChartSupport
	def get_session_data()
		image = session[params["id"]]
		stype = params.has_key?("stype") ? params["stype"] : nil
		options = { :disposition => "inline" }
		options[:filename] = params["filename"] if params.has_key?("filename")
		options[:type] = "text/html; charset=utf-8"
		if image.length >= 3
			c0 = image[0]
			c1 = image[1]
			c2 = image[2]
			if (c0 == 0x47) && (c1 == 0x49)
				options[:type] = "image/gif"
			elsif (c1 == 0x50) && (c2 == 0x4e)
				options[:type] = "image/png"
			elsif (c0 == 0x42) && (c1 == 0x4d)
				options[:type] = "image/bmp"
			elsif (c0 == 0xff) && (c1 == 0xd8)
				options[:type] = "image/jpeg"
			elsif (c0 == 0) && (c1 == 0)
				options[:type] = "image/vnd.wap.wbmp"
			elsif ".svg" == stype
				options[:type] = "image/svg+xml"
			end
			if (c0 == 0x1f) && (c1 == 0x8b)
				headers["Content-Encoding"] = "gzip"
			end
		end
		send_data(image, options)
	end
end

end #module
