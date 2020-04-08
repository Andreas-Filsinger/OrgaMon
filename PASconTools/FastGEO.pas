(*************************************************************************)
(*                                                                       *)
(*                             FASTGEO                                   *)
(*                                                                       *)
(*                2D/3D Computational Geometry Algorithms                *)
(*                        Release Version 5.0.1                          *)
(*                                                                       *)
(* Author: Arash Partow 1997-2005                                        *)
(* URL: http://fastgeo.partow.net                                        *)
(*      http://www.partow.net/projects/fastgeo/index.html                *)
(*                                                                       *)
(* Copyright notice:                                                     *)
(*                                                                       *)
(* Free use of the FastGEO computational geometry library is permitted   *)
(* under the guidelines and in accordance with the most current version  *)
(* of the Common Public License.                                         *)
(* http://www.opensource.org/licenses/cpl.php                            *)
(*                                                                       *)
(*************************************************************************)
unit FastGEO;

interface
const VersionInformation = 'FastGEO Version 5.0.1';
const AuthorInformation = 'Arash Partow (1997-2005)';
const EpochInformation = 'Delta-Zulu';
const RecentUpdate = '01-01-2005';

(****************************************************************************)
(********************[ Basic Geometric Structure Types ]*********************)
(****************************************************************************)
(**************[  Vertex type   ]***************)
type
  TPoint2D = record x, y: Double; end;
type TPoint2DPtr = ^TPoint2D;
// AF
type TVectorPoint2D = array of TPoint2D;
// AF
(**************[ 3D Vertex type ]***************)
type TPoint3D = record x, y, z: Double; end;
type TPoint3DPtr = ^TPoint3D;

(**************[  Quadix type   ]***************)
type TQuadix2D = array[1..4] of TPoint2D;
type TQuadix2DPtr = ^TQuadix2D;
type TQuadix3D = array[1..4] of TPoint3D;
type TQuadix3DPtr = ^TQuadix3D;

(**************[ Rectangle type ]***************)
type TRectangle = array[1..2] of TPoint2D;
type TRectanglePtr = ^TRectangle;

(**************[ Triangle type  ]***************)
type TTriangle2D = array[1..3] of TPoint2D;
type TTriangle2DPtr = ^TTRiangle2D;
type TTriangle3D = array[1..3] of TPoint3D;
type TTriangle3DPtr = ^TTriangle3D;

(**************[  Segment type  ]***************)
type TLine2D = array[1..2] of TPoint2D;
type TLine2DPtr = ^TLine2D;
type TLine3D = array[1..2] of TPoint3D;
type TLine3DPtr = ^TLine3D;
type TSegment2D = array[1..2] of TPoint2D;
type TSegment2DPtr = ^TSegment2D;
type TSegment3D = array[1..2] of TPoint3D;
type TSegment3DPtr = ^TSegment3D;

(**************[  Circle type   ]***************)
type TCircle = record x, y, Radius: Double; end;
type TCirclePtr = ^TCircle;

(**************[  Sphere type   ]***************)
type TSphere = record x, y, z, Radius: Double; end;
type TSpherePtr = ^TSphere;

(**************[ 2D Vector type ]***************)
type TVector2D = record x, y: Double; end;
type TVector2DPtr = ^TVector2D;
type TVector2DArray = array of TVector2D;
(**************[ 3D Vector type ]***************)
type TVector3D = record x, y, z: Double; end;
type TVector3DPtr = ^TVector3D;
type TVector3DArray = array of TVector3D;

(**********[ Polygon Vertex type  ]************)
type TPolygon2D = array of TPoint2D;
type TPolygonPtr = ^TPolygon2D;
type TPolygon3D = array of TPoint3D;
type TPolygon3DPtr = ^TPolygon3D;
type TPolyhedron = array of TPolygon3D;
type TPolyhedronPtr = ^TPolyhedron;

(**************[ Plane type ]******************)
type TPlane2D = record a, b, c, d: Double; end;
type TPlane2DPtr = ^TPlane2D;

type TInclusion = (Fully, Partially, Outside, Unknown);
type TTriangletype = (Equilateral, Isosceles, Right, Scalene, Obtuse, TUnknown);

(********[ Universal Geometric Variable ]********)
type TGeometricObjectTypes = (
    goPoint2D,
    goPoint3D,
    goLine2D,
    goLine3D,
    goSegment2D,
    goSegment3D,
    goQuadix2D,
    goQuadix3D,
    goTriangle2D,
    goTriangle3D,
    goRectangle,
    goCircle,
    goSphere,
    goPolygon2D,
    goPolygon3D,
    goPolyhedron
    );

type TGeometricObject = record
    case TGeometricObjectTypes of
      goPoint2D: (Point2D: TPoint2D);
      goPoint3D: (Point3D: TPoint3D);
      goLine2D: (Line2D: TLine2D);
      goLine3D: (Line3D: TLine3D);
      goSegment2D: (Segment2D: TSegment2D);
      goSegment3D: (Segment3D: TSegment3D);
      goQuadix2D: (Quadix2D: TQuadix2D);
      goQuadix3D: (Quadix3D: TQuadix3D);
      goTriangle2D: (Triangle2D: TTriangle2D);
      goTriangle3D: (Triangle3D: TTriangle3D);
      goRectangle: (Rectangle: TRectangle);
      goCircle: (Circle: TCircle);
      goSphere: (Sphere: TSphere);
      goPolygon2D: (Polygon: TPolygonPtr);
      goPolygon3D: (Polygon3D: TPolygon3DPtr);
      goPolyhedron: (Polyhedron: TPolyhedronPtr);
  end;


const
(************[ Orientation Constants ]**********)
  RightHandSide = -1;
  LeftHandSide = +1;
  Clockwise = -1;
  CounterClockwise = +1;

function Orientation(const x1, y1, x2, y2, Px, Py: Double): Integer; overload;
function Orientation(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: Double): Integer; overload;
function Orientation(const Pnt1, Pnt2: TPoint2D; const Px, Py: Double): Integer; overload;
function Orientation(const Pnt1, Pnt2, Pnt3: TPoint2D): Integer; overload;
function Orientation(const Ln: TLine2D; const Pnt: TPoint2D): Integer; overload;
function Orientation(const Seg: TSegment2D; const Pnt: TPoint2D): Integer; overload;
function Orientation(const Pnt1, Pnt2, Pnt3: TPoint3D; const Px, Py, Pz: Double): Integer; overload;
function Orientation(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Integer; overload;
function Orientation(const Tri: TTriangle3D; const Pnt: TPoint3D): Integer; overload;
function Signed(const x1, y1, x2, y2, Px, Py: Double): Double; overload;
function Signed(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: Double): Double; overload;
function Signed(const Pnt1, Pnt2: TPoint2D; const Px, Py: Double): Double; overload;
function Signed(const Pnt1, Pnt2, Pnt3: TPoint2D): Double; overload;
function Signed(const Ln: TLine2D; const Pnt: TPoint2D): Double; overload;
function Signed(const Seg: TSegment2D; const Pnt: TPoint2D): Double; overload;
function Signed(const Pnt1, Pnt2, Pnt3: TPoint3D; const Px, Py, Pz: Double): Double; overload;
function Signed(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Double; overload;
function Signed(const Tri: TTriangle3D; const Pnt: TPoint3D): Double; overload;
function Collinear(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function Collinear(const x1, y1, x2, y2, x3, y3, Epsilon: Double): Boolean; overload;
function Collinear(const PntA, PntB, PntC: TPoint2D): Boolean; overload;
function Collinear(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function Collinear(const PntA, PntB, PntC: TPoint3D): Boolean; overload;
function Coplanar(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean; overload;
function Coplanar(const PntA, PntB, PntC, PntD: TPoint3D): Boolean; overload;
function IsPointCollinear(const x1, y1, x2, y2, Px, Py: Double): Boolean; overload;
function IsPointCollinear(const PntA, PntB, PntC: TPoint2D): Boolean; overload;
function IsPointCollinear(const PntA, PntB: TPoint2D; const Px, Py: Double): Boolean; overload;
function IsPointCollinear(const Segment: TSegment2D; const PntC: TPoint2D): Boolean; overload;
function IsPointCollinear(const x1, y1, z1, x2, y2, z2, Px, Py, Pz: Double): Boolean; overload;
function IsPointCollinear(const PntA, PntB, PntC: TPoint3D): Boolean; overload;
function IsPointCollinear(const Segment: TSegment3D; const PntC: TPoint3D): Boolean; overload;
function IsPointOnRightSide(const x, y: Double; const Seg: TSegment2D): Boolean; overload;
function IsPointOnRightSide(const Pnt: TPoint2D; const Seg: TSegment2D): Boolean; overload;
function IsPointOnRightSide(const x, y: Double; const Ln: TLine2D): Boolean; overload;
function IsPointOnRightSide(const Pnt: TPoint2D; const Ln: TLine2D): Boolean; overload;
function IsPointOnLeftSide(const x, y: Double; const Seg: TSegment2D): Boolean; overload;
function IsPointOnLeftSide(const Pnt: TPoint2D; const Seg: TSegment2D): Boolean; overload;
function IsPointOnLeftSide(const x, y: Double; const Ln: TLine2D): Boolean; overload;
function IsPointOnLeftSide(const Pnt: TPoint2D; const Ln: TLine2D): Boolean; overload;

function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double; out ix, iy: Double): Boolean; overload;
function Intersect(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean; overload;
function Intersect(const Seg1, Seg2: TSegment2D): Boolean; overload;
function Intersect(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean; overload;
function Intersect(const P1, P2, P3, P4: TPoint3D): Boolean; overload;
function Intersect(const Seg1, Seg2: TSegment3D): Boolean; overload;
function Intersect(const Seg: TSegment2D; const Rec: TRectangle): Boolean; overload;
function Intersect(const Seg: TSegment2D; const Tri: TTriangle2D): Boolean; overload;
function Intersect(const Seg: TSegment2D; const Quad: TQuadix2D): Boolean; overload;
function Intersect(Seg: TSegment2D; const Cir: TCircle): Boolean; overload;
function Intersect(const Seg: TSegment3D; const Sphere: TSphere): Boolean; overload;
function Intersect(const Cir1, Cir2: TCircle): Boolean; overload;
function Intersect(const Line: TLine3D; const Triangle: TTriangle3D; out IPoint: TPoint3D): Boolean; overload;
procedure IntersectionPoint(const x1, y1, x2, y2, x3, y3, x4, y4: Double; out Nx, Ny: Double); overload;
procedure IntersectionPoint(const P1, P2, P3, P4: TPoint2D; out Nx, Ny: Double); overload;
function IntersectionPoint(const P1, P2, P3, P4: TPoint2D): TPoint2D; overload;
function IntersectionPoint(const Seg1, Seg2: TSegment2D): TPoint2D; overload;
function IntersectionPoint(const Ln1, Ln2: TLine2D): TPoint2D; overload;
procedure IntersectionPoint(const Cir1, Cir2: TCircle; out Pnt1, Pnt2: TPoint2D); overload;
procedure IntersectionPoint(const Line: TLine3D; const Triangle: TTriangle3D; out IPoint: TPoint3D); overload;
function VertexAngle(x1, y1, x2, y2, x3, y3: Double): Double; overload;
function VertexAngle(const Pnt1, Pnt2, Pnt3: TPoint2D): Double; overload;
function VertexAngle(x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Double; overload;
function VertexAngle(const Pnt1, Pnt2, Pnt3: TPoint3D): Double; overload;
function SegmentIntersectAngle(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Double; overload;
function SegmentIntersectAngle(const Seg1, Seg2: TSegment2D): Double; overload;
function SegmentIntersectAngle(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Double; overload;
function SegmentIntersectAngle(const Seg1, Seg2: TSegment3D): Double; overload;
function InPortal(const P: TPoint2D): Boolean; overload;
function InPortal(const P: TPoint3D): Boolean; overload;
function HighestPoint(const Polygon: TPolygon2D): TPoint2D; overload;
function HighestPoint(const Tri: TTriangle2D): TPoint2D; overload;
function HighestPoint(const Tri: TTriangle3D): TPoint3D; overload;
function HighestPoint(const Quadix: TQuadix2D): TPoint2D; overload;
function HighestPoint(const Quadix: TQuadix3D): TPoint3D; overload;
function LowestPoint(const Polygon: TPolygon2D): TPoint2D; overload;
function LowestPoint(const Tri: TTriangle2D): TPoint2D; overload;
function LowestPoint(const Tri: TTriangle3D): TPoint3D; overload;
function LowestPoint(const Quadix: TQuadix2D): TPoint2D; overload;
function LowestPoint(const Quadix: TQuadix3D): TPoint3D; overload;
function Coincident(const Pnt1, Pnt2: TPoint2D): Boolean; overload;
function Coincident(const Pnt1, Pnt2: TPoint3D): Boolean; overload;
function Coincident(const Seg1, Seg2: TSegment2D): Boolean; overload;
function Coincident(const Seg1, Seg2: TSegment3D): Boolean; overload;
function Coincident(const Tri1, Tri2: TTriangle2D): Boolean; overload;
function Coincident(const Tri1, Tri2: TTriangle3D): Boolean; overload;
function Coincident(const Rect1, Rect2: TRectangle): Boolean; overload;
function Coincident(const Quad1, Quad2: TQuadix2D): Boolean; overload;
function Coincident(const Quad1, Quad2: TQuadix3D): Boolean; overload;
function Coincident(const Cir1, Cir2: TCircle): Boolean; overload;
function Coincident(const Sphr1, Sphr2: TSphere): Boolean; overload;
procedure PerpendicularPntToSegment(const x1, y1, x2, y2, Px, Py: Double; out Nx, Ny: Double); overload;
function PerpendicularPntToSegment(const Seg: TSegment2D; const Pnt: TPoint2D): TPoint2D; overload;
procedure PerpendicularPntToSegment(const x1, y1, z1, x2, y2, z2, Px, Py, Pz: Double; out Nx, Ny, Nz: Double); overload;
function PerpendicularPntToSegment(const Seg: TSegment3D; const Pnt: TPoint3D): TPoint3D; overload;
procedure PerpendicularPntToRay(const Rx1, Ry1, Rx2, Ry2, Px, Py: Double; out Nx, Ny: Double); overload;
function PerpendicularPntToRay(const Seg: TSegment2D; const Pnt: TPoint2D): TPoint2D; overload;
function PointToSegmentDistance(const Px, Py, x1, y1, x2, y2: Double): Double; overload;
function PointToSegmentDistance(const Pnt: TPoint2D; const Seg: TSegment2D): Double; overload;
function PointToSegmentDistance(const Px, Py, Pz, x1, y1, z1, x2, y2, z2: Double): Double; overload;
function PointToSegmentDistance(const Pnt: TPoint3D; const Seg: TSegment3D): Double; overload;
function PointToRayDistance(const Px, Py, x1, y1, x2, y2: Double): Double; overload;
function PointToRayDistance(const Pnt: TPoint2D; const Seg: TSegment2D): Double; overload;
function SegmentsParallel(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function SegmentsParallel(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean; overload;
function SegmentsParallel(const Seg1, Seg2: TSegment2D): Boolean; overload;
function SegmentsParallel(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean; overload;
function SegmentsParallel(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Boolean; overload;
function SegmentsParallel(const Seg1, Seg2: TSegment3D): Boolean; overload;
function SegmentsPerpendicular(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function SegmentsPerpendicular(const Ln1, Ln2: TLine2D): Boolean; overload;
function SegmentsPerpendicular(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean; overload;
function SegmentsPerpendicular(const Ln1, Ln2: TLine3D): Boolean; overload;
procedure SetPlane(const xh, xl, yh, yl: Double); overload;
procedure SetPlane(const Pnt1, Pnt2: TPoint2D); overload;
procedure SetPlane(const Rec: TRectangle); overload;
function LineToLineIntersect(x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function LineToLineIntersect(Ln1, Ln2: TLine2D): Boolean; overload;
function RectangleToRectangleIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function RectangleToRectangleIntersect(const Rec1, Rec2: TRectangle): Boolean; overload;
function CircleInCircle(const Cir1, Cir2: TCircle): Boolean;
function IsTangent(Seg: TSegment2D; const Cir: TCircle): Boolean;
function PointOfReflection(const Sx1, Sy1, Sx2, Sy2, P1x, P1y, P2x, P2y: Double; out RPx, RPy: Double): Boolean; overload;
function PointOfReflection(const Seg: TSegment2D; const P1, P2: tPoint2D; out RP: TPoint2D): Boolean; overload;
function Distance(const x1, y1, x2, y2: Double): Double; overload;
function Distance(const Pnt1, Pnt2: TPoint2D): Double; overload;
function Distance(const x1, y1, z1, x2, y2, z2: Double): Double; overload;
function Distance(const Pnt1, Pnt2: TPoint3D): Double; overload;
function Distance(const Segment: TSegment2D): Double; overload;
function Distance(const Segment: TSegment3D): Double; overload;
function Distance(const Cir1, Cir2: TCircle): Double; overload;
function Distance(const Seg1, Seg2: TSegment3D): Double; overload;

function DistanceEarth(const Pnt1, Pnt2: TPoint2D): Double; overload;
function DistanceEarth(const x1, y1, x2, y2: Double): Double; overload;

function ApproxEllipticalDistance(const Pnt1, Pnt2: TPoint2D): Double; overload;
function ApproxEllipticalDistance(llat1, llon1, llat2, llon2: Double): Double; overload;

function LayDistance(const x1, y1, x2, y2: Double): Double; overload;
function LayDistance(const Pnt1, Pnt2: TPoint2D): Double; overload;
function LayDistance(const x1, y1, z1, x2, y2, z2: Double): Double; overload;
function LayDistance(const Pnt1, Pnt2: TPoint3D): Double; overload;
function LayDistance(const Seg: TSegment2D): Double; overload;
function LayDistance(const Seg: TSegment3D): Double; overload;
function LayDistance(const Cir1, Cir2: TCircle): Double; overload;
function ManhattanDistance(const x1, y1, x2, y2: Double): Double; overload;
function ManhattanDistance(const Pnt1, Pnt2: TPoint2D): Double; overload;
function ManhattanDistance(const x1, y1, z1, x2, y2, z2: Double): Double; overload;
function ManhattanDistance(const Pnt1, Pnt2: TPoint3D): Double; overload;
function ManhattanDistance(const Segment: TSegment2D): Double; overload;
function ManhattanDistance(const Segment: TSegment3D): Double; overload;
function ManhattanDistance(const Cir1, Cir2: TCircle): Double; overload;
function TriangleType(const x1, y1, x2, y2, x3, y3: Double): TTriangleType; overload;
function TriangleType(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TTriangleType; overload;
function TriangleType(const Pnt1, Pnt2, Pnt3: TPoint2D): TTriangleType; overload;
function TriangleType(const Pnt1, Pnt2, Pnt3: TPoint3D): TTriangleType; overload;
function TriangleType(const Tri: TTriangle2D): TTriangleType; overload;
function TriangleType(const Tri: TTriangle3D): TTriangleType; overload;
function IsEquilateralTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function IsEquilateralTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function IsEquilateralTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean; overload;
function IsEquilateralTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean; overload;
function IsEquilateralTriangle(const Tri: TTriangle2D): Boolean; overload;
function IsEquilateralTriangle(const Tri: TTriangle3D): Boolean; overload;
function IsIsoscelesTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function IsIsoscelesTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function IsIsoscelesTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean; overload;
function IsIsoscelesTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean; overload;
function IsIsoscelesTriangle(const Tri: TTriangle2D): Boolean; overload;
function IsIsoscelesTriangle(const Tri: TTriangle3D): Boolean; overload;
function IsRightTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function IsRightTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function IsRightTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean; overload;
function IsRightTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean; overload;
function IsRightTriangle(const Tri: TTriangle2D): Boolean; overload;
function IsRightTriangle(const Tri: TTriangle3D): Boolean; overload;
function IsScaleneTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function IsScaleneTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function IsScaleneTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean; overload;
function IsScaleneTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean; overload;
function IsScaleneTriangle(const Tri: TTriangle2D): Boolean; overload;
function IsScaleneTriangle(const Tri: TTriangle3D): Boolean; overload;
function IsObtuseTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function IsObtuseTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean; overload;
function IsObtuseTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean; overload;
function IsObtuseTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean; overload;
function IsObtuseTriangle(const Tri: TTriangle2D): Boolean; overload;
function IsObtuseTriangle(const Tri: TTriangle3D): Boolean; overload;
function PointInTriangle(const Px, Py, x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function PointInTriangle(const Pnt: TPoint2D; const Tri: TTriangle2D): Boolean; overload;
function PointInCircle(const Px, Py: Double; const Circle: TCircle): Boolean; overload;
function PointInCircle(const Pnt: TPoint2D; const Circle: TCircle): Boolean; overload;
function PointOnCircle(const Px, Py: Double; const Circle: TCircle): Boolean; overload;
function PointOnCircle(const Pnt: TPoint2D; const Circle: TCircle): Boolean; overload;
function TriangleInCircle(const Tri: TTriangle2D; const Circle: TCircle): Boolean;
function TriangleOutsideCircle(const Tri: TTriangle2D; const Circle: TCircle): Boolean;
function RectangleInCircle(const Rect: TRectangle; const Circle: TCircle): Boolean;
function RectangleOutsideCircle(const Rect: TRectangle; const Circle: TCircle): Boolean;
function QuadixInCircle(const Quad: TQuadix2D; const Circle: TCircle): Boolean;
function QuadixOutsideCircle(const Quad: TQuadix2D; const Circle: TCircle): Boolean;
function PointInRectangle(const Px, Py: Double; const x1, y1, x2, y2: Double): Boolean; overload;
function PointInRectangle(const Pnt: TPoint2D; const x1, y1, x2, y2: Double): Boolean; overload;
function PointInRectangle(const Px, Py: Double; const Rec: TRectangle): Boolean; overload;
function PointInRectangle(const Pnt: TPoint2D; const Rec: TRectangle): Boolean; overload;
function TriangleInRectangle(const Tri: TTriangle2D; const Rec: TRectangle): Boolean;
function TriangleOutsideRectangle(const Tri: TTriangle2D; const Rec: TRectangle): Boolean;
function QuadixInRectangle(const Quad: TQuadix2D; const Rec: TRectangle): Boolean;
function QuadixOutsideRectangle(const Quad: TQuadix2D; const Rec: TRectangle): Boolean;
function RectangleInRectangle(const Rec1, Rec2 : TRectangle):boolean;
function PointInQuadix(const Px, Py, x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function PointInQuadix(const Pnt, Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean; overload;
function PointInQuadix(const Pnt: TPoint2D; const Quad: TQuadix2D): Boolean; overload;
function TriangleInQuadix(const Tri: TTriangle2D; const Quad: TQuadix2D): Boolean;
function TriangleOutsideQuadix(const Tri: TTriangle2D; const Quad: TQuadix2D): Boolean;
function PointInSphere(const x, y, z: Double; const Sphere: TSphere): Boolean; overload;
function PointInSphere(const Pnt3D: TPoint3D; const Sphere: TSphere): Boolean; overload;
function PointOnSphere(const Pnt3D: TPoint3D; const Sphere: TSphere): Boolean; overload;
function PolyhedronInSphere(const Poly: TPolyhedron; const Sphere: TSphere): TInclusion;
function PointOnPerimeter(const Px, Py, x1, y1, x2, y2: Double): Boolean; overload;
function PointOnPerimeter(const Px, Py, x1, y1, x2, y2, x3, y3: Double): Boolean; overload;
function PointOnPerimeter(const Px, Py, x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean; overload;
function PointOnPerimeter(const Point: TPoint2D; const Rect: TRectangle): Boolean; overload;
function PointOnPerimeter(const Point: TPoint2D; const Tri: TTriangle2D): Boolean; overload;
function PointOnPerimeter(const Point: TPoint2D; const Quad: TQuadix2D): Boolean; overload;
function PointOnPerimeter(const Point: TPoint2D; const Cir: TCircle): Boolean; overload;
function GeometricSpan(const Pnt: array of TPoint2D): Double; overload;
function GeometricSpan(const Pnt: array of TPoint3D): Double; overload;
procedure CreateEquilateralTriangle(x1, y1, x2, y2: Double; out x3, y3: Double); overload;
procedure CreateEquilateralTriangle(const Pnt1, Pnt2: TPoint2D; out Pnt3: TPoint2D); overload;
procedure TorricelliPoint(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double); overload;
function TorricelliPoint(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D; overload;
function TorricelliPoint(const Tri: TTriangle2D): TPoint2D; overload;
procedure Incenter(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double); overload;
function Incenter(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D; overload;
function Incenter(const Tri: TTriangle2D): TPoint2D; overload;
procedure Circumcenter(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double); overload;
function Circumcenter(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D; overload;
function Circumcenter(const Tri: TTriangle2D): TPoint2D; overload;
function Circumcircle(const P1, P2, P3: TPoint2D): TCircle; overload;
function Circumcircle(const Tri: TTriangle2D): TCircle; overload;
function InscribedCircle(const P1, P2, P3: TPoint2D): TCircle; overload;
function InscribedCircle(const Tri: TTriangle2D): TCircle; overload;
function ClosestPointOnCircleFromSegment(const Cir: TCircle; Seg: TSegment2D): TPoint2D;
function ClosestPointOnSphereFromSegment(const Sphr: TSphere; Seg: TSegment3D): TPoint3D;
procedure SegmentMidPoint(const x1, y1, x2, y2: Double; out midx, midy: Double); overload;
function SegmentMidPoint(const P1, P2: TPoint2D): TPoint2D; overload;
function SegmentMidPoint(const Seg: TSegment2D): TPoint2D; overload;
procedure SegmentMidPoint(const x1, y1, z1, x2, y2, z2: Double; out midx, midy, midz: Double); overload;
function SegmentMidPoint(const P1, P2: TPoint3D): TPoint3D; overload;
function SegmentMidPoint(const Seg: TSegment3D): TPoint3D; overload;
function OrthoCenter(const x1, y1, x2, y2, x3, y3: Double): TPoint2D; overload;
function OrthoCenter(const Pnt1, Pnt2, CPnt: TPoint2D): TPoint2D; overload;
function OrthoCenter(const Ln1, Ln2, Ln3: TLine2D): TPoint2D; overload;
function OrthoCenter(const Tri: TTriangle2D): TPoint2D; overload;
function PolygonCentroid(const Polygon: TPolygon2D): TPoint2D; overload;
function PolygonCentroid(const Polygon: array of TPoint3D): TPoint3D; overload;
function PolygonSegmentIntersect(const Seg: TSegment2D; const Poly: TPolygon2D): Boolean;
function PolygonInPolygon(const Poly1, Poly2: TPolygon2D): Boolean;
function PolygonIntersect(const Poly1, Poly2: TPolygon2D): Boolean;
function PointInConvexPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean; overload;
function PointInConvexPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean; overload;
function PointInConcavePolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean; overload;
function PointInConcavePolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean; overload;
function PointOnPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean; overload;
function PointOnPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean; overload;
function PointInPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean; overload;
function PointInPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean; overload;
function ConvexQuadix(const Quad: TQuadix2D): Boolean;
function ComplexPolygon(const Poly: TPolygon2D): Boolean;
function SimplePolygon(const Poly: TPolygon2D): Boolean;
function ConvexPolygon(const Poly: TPolygon2D): Boolean;
function ConcavePolygon(const Poly: TPolygon2D): Boolean;
function RectangularHull(const Point: array of TPoint2D): TRectangle; overload;
function RectangularHull(const Poly: TPolygon2D): TRectangle; overload;
function CircularHull(const Poly: TPolygon2D): TCircle;
function SphereHull(const Poly: array of TPoint3D): TSphere;
function Clip(Seg: TSegment2D; const Rec: TRectangle): TSegment2D; overload;
function Clip(const Seg: TSegment2D; const Tri: TTriangle2D): TSegment2D; overload;
function Clip(const Seg: TSegment2D; const Quad: TQuadix2D): TSegment2D; overload;
function Area(const Pnt1, Pnt2, Pnt3: TPoint2D): Double; overload;
function Area(const Pnt1, Pnt2, Pnt3: TPoint3D): Double; overload;
function Area(const Tri: TTriangle2D): Double; overload;
function Area(const Tri: TTriangle3D): Double; overload;
function Area(const Quad: TQuadix2D): Double; overload;
function Area(const Quad: TQuadix3D): Double; overload;
function Area(const Rec: TRectangle): Double; overload;
function Area(const Cir: TCircle): Double; overload;
function Area(const Poly: TPolygon2D): Double; overload;
function Perimeter(const Tri: TTriangle2D): Double; overload;
function Perimeter(const Tri: TTriangle3D): Double; overload;
function Perimeter(const Quad: TQuadix2D): Double; overload;
function Perimeter(const Quad: TQuadix3D): Double; overload;
function Perimeter(const Rec: TRectangle): Double; overload;
function Perimeter(const Cir: TCircle): Double; overload;
function Perimeter(const Poly: TPolygon2D): Double; overload;
procedure Rotate(RotAng: Double; const x, y: Double; out Nx, Ny: Double); overload;
procedure Rotate(const RotAng: Double; const x, y, ox, oy: Double; out Nx, Ny: Double); overload;
function Rotate(const RotAng: Double; const Pnt: TPoint2D): TPoint2D; overload;
function Rotate(const RotAng: Double; const Pnt, OPnt: TPoint2D): TPoint2D; overload;
function Rotate(const RotAng: Double; const Seg: TSegment2D): TSegment2D; overload;
function Rotate(const RotAng: Double; const Seg: TSegment2D; const OPnt: TPoint2D): TSegment2D; overload;
function Rotate(const RotAng: Double; const Tri: TTriangle2D): TTriangle2D; overload;
function Rotate(const RotAng: Double; const Tri: TTriangle2D; const OPnt: TPoint2D): TTriangle2D; overload;
function Rotate(const RotAng: Double; const Quad: TQuadix2D): TQuadix2D; overload;
function Rotate(const RotAng: Double; const Quad: TQuadix2D; const OPnt: TPoint2D): TQuadix2D; overload;
function Rotate(const RotAng: Double; Poly: TPolygon2D): TPolygon2D; overload;
function Rotate(const RotAng: Double; Poly: TPolygon2D; const OPnt: TPoint2D): TPolygon2D; overload;
procedure Rotate(const Rx, Ry, Rz: Double; const x, y, z: Double; out Nx, Ny, Nz: Double); overload;
procedure Rotate(const Rx, Ry, Rz: Double; const x, y, z, ox, oy, oz: Double; out Nx, Ny, Nz: Double); overload;
function Rotate(const Rx, Ry, Rz: Double; const Pnt: TPoint3D): TPoint3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Pnt, OPnt: TPoint3D): TPoint3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Seg: TSegment3D): TSegment3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Seg: TSegment3D; const OPnt: TPoint3D): TSegment3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Tri: TTriangle3D): TTriangle3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Tri: TTriangle3D; const OPnt: TPoint3D): TTriangle3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Quad: TQuadix3D): TQuadix3D; overload;
function Rotate(const Rx, Ry, Rz: Double; const Quad: TQuadix3D; const OPnt: TPoint3D): TQuadix3D; overload;
function Rotate(const Rx, Ry, Rz: Double; Poly: TPolygon3D): TPolygon3D; overload;
function Rotate(const Rx, Ry, Rz: Double; Poly: TPolygon3D; const OPnt: TPoint3D): TPolygon3D; overload;
procedure FastRotate(RotAng: Integer; const x, y: Double; out Nx, Ny: Double); overload;
procedure FastRotate(RotAng: Integer; x, y, ox, oy: Double; out Nx, Ny: Double); overload;
function FastRotate(const RotAng: Integer; const Pnt: TPoint2D): TPoint2D; overload;
function FastRotate(const RotAng: Integer; const Pnt, OPnt: TPoint2D): TPoint2D; overload;
function FastRotate(const RotAng: Integer; const Seg: TSegment2D): TSegment2D; overload;
function FastRotate(const RotAng: Integer; const Seg: TSegment2D; const OPnt: TPoint2D): TSegment2D; overload;
function FastRotate(const RotAng: Integer; const Tri: TTriangle2D): TTriangle2D; overload;
function FastRotate(const RotAng: Integer; const Tri: TTriangle2D; const OPnt: TPoint2D): TTriangle2D; overload;
function FastRotate(const RotAng: Integer; const Quad: TQuadix2D): TQuadix2D; overload;
function FastRotate(const RotAng: Integer; const Quad: TQuadix2D; const OPnt: TPoint2D): TQuadix2D; overload;
function FastRotate(const RotAng: Integer; Poly: TPolygon2D): TPolygon2D; overload;
function FastRotate(const RotAng: Integer; Poly: TPolygon2D; const OPnt: TPoint2D): TPolygon2D; overload;
procedure FastRotate(Rx, Ry, Rz: Integer; const x, y, z: Double; out Nx, Ny, Nz: Double); overload;
procedure FastRotate(const Rx, Ry, Rz: Integer; const x, y, z, ox, oy, oz: Double; out Nx, Ny, Nz: Double); overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Pnt: TPoint3D): TPoint3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Pnt, OPnt: TPoint3D): TPoint3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Seg: TSegment3D): TSegment3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Seg: TSegment3D; const OPnt: TPoint3D): TSegment3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Tri: TTriangle3D): TTriangle3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Tri: TTriangle3D; const OPnt: TPoint3D): TTriangle3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Quad: TQuadix3D): TQuadix3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; const Quad: TQuadix3D; const OPnt: TPoint3D): TQuadix3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; Poly: TPolygon3D): TPolygon3D; overload;
function FastRotate(const Rx, Ry, Rz: Integer; Poly: TPolygon3D; const OPnt: TPoint3D): TPolygon3D; overload;
function Translate(const Dx, Dy: Double; const Pnt: TPoint2D): TPoint2D; overload;
function Translate(const Dx, Dy: Double; const Ln: TLine2D): TLine2D; overload;
function Translate(const Dx, Dy: Double; const Seg: TSegment2D): TSegment2D; overload;
function Translate(const Dx, Dy: Double; const Tri: TTriangle2D): TTriangle2D; overload;
function Translate(const Dx, Dy: Double; const Quad: TQuadix2D): TQuadix2D; overload;
function Translate(const Dx, Dy: Double; const Rec: TRectangle): TRectangle; overload;
function Translate(const Dx, Dy: Double; const Cir: TCircle): TCircle; overload;
function Translate(const Dx, Dy: Double; const Poly: TPolygon2D): TPolygon2D; overload;
function Translate(const Pnt: TPoint2D; const Poly: TPolygon2D): TPolygon2D; overload;
function Translate(const Dx, Dy, Dz: Double; const Pnt: TPoint3D): TPoint3D; overload;
function Translate(const Dx, Dy, Dz: Double; const Ln: TLine3D): TLine3D; overload;
function Translate(const Dx, Dy, Dz: Double; const Seg: TSegment3D): TSegment3D; overload;
function Translate(const Dx, Dy, Dz: Double; const Tri: TTriangle3D): TTriangle3D; overload;
function Translate(const Dx, Dy, Dz: Double; const Quad: TQuadix3D): TQuadix3D; overload;
function Translate(const Dx, Dy, Dz: Double; const Sphere: TSphere): TSphere; overload;
function Translate(const Dx, Dy, Dz: Double; const Poly: TPolygon3D): TPolygon3D; overload;
function Translate(const Pnt: TPoint3D; const Poly: TPolygon3D): TPolygon3D; overload;
function Scale(const Dx, Dy: Double; const Pnt: TPoint2D): TPoint2D; overload;
function Scale(const Dx, Dy: Double; const Ln: TLine2D): TLine2D; overload;
function Scale(const Dx, Dy: Double; const Seg: TSegment2D): TSegment2D; overload;
function Scale(const Dx, Dy: Double; const Tri: TTriangle2D): TTriangle2D; overload;
function Scale(const Dx, Dy: Double; const Quad: TQuadix2D): TQuadix2D; overload;
function Scale(const Dx, Dy: Double; const Rec: TRectangle): TRectangle; overload;
function Scale(const Dr: Double; const Cir: TCircle): TCircle; overload;
function Scale(const Dx, Dy: Double; const Poly: TPolygon2D): TPolygon2D; overload;
function Scale(const Dx, Dy, Dz: Double; const Pnt: TPoint3D): TPoint3D; overload;
function Scale(const Dx, Dy, Dz: Double; const Ln: TLine3D): TLine3D; overload;
function Scale(const Dx, Dy, Dz: Double; const Seg: TSegment3D): TSegment3D; overload;
function Scale(const Dx, Dy, Dz: Double; const Tri: TTriangle3D): TTriangle3D; overload;
function Scale(const Dx, Dy, Dz: Double; const Quad: TQuadix3D): TQuadix3D; overload;
function Scale(const Dr: Double; const Sphere: TSphere): TSphere; overload;
function Scale(const Dx, Dy, Dz: Double; const Poly: TPolygon3D): TPolygon3D; overload;
procedure ShearXAxis(const Shear, x, y: Double; out Nx, Ny: Double); overload;
function ShearXAxis(const Shear: Double; const Pnt: TPoint2D): TPoint2D; overload;
function ShearXAxis(const Shear: Double; const Seg: TSegment2D): TSegment2D; overload;
function ShearXAxis(const Shear: Double; const Tri: TTriangle2D): TTriangle2D; overload;
function ShearXAxis(const Shear: Double; const Quad: TQuadix2D): TQuadix2D; overload;
function ShearXAxis(const Shear: Double; Poly: TPolygon2D): TPolygon2D; overload;
procedure ShearYAxis(const Shear, x, y: Double; out Nx, Ny: Double); overload;
function ShearYAxis(const Shear: Double; const Pnt: TPoint2D): TPoint2D; overload;
function ShearYAxis(const Shear: Double; const Seg: TSegment2D): TSegment2D; overload;
function ShearYAxis(const Shear: Double; const Tri: TTriangle2D): TTriangle2D; overload;
function ShearYAxis(const Shear: Double; const Quad: TQuadix2D): TQuadix2D; overload;
function ShearYAxis(const Shear: Double; Poly: TPolygon2D): TPolygon2D; overload;
function EquatePoint(const x, y: Double): TPoint2D; overload;
function EquatePoint(const x, y, z: Double): TPoint3D; overload;
procedure EquatePoint(const x, y: Double; out Point: TPoint2D); overload;
procedure EquatePoint(const x, y, z: Double; out Point: TPoint3D); overload;
function EquateSegment(const x1, y1, x2, y2: Double): TSegment2D; overload;
function EquateSegment(const x1, y1, z1, x2, y2, z2: Double): TSegment3D; overload;
procedure EquateSegment(const x1, y1, x2, y2: Double; out Seg: TSegment2D); overload;
procedure EquateSegment(const x1, y1, z1, x2, y2, z2: Double; out Seg: TSegment3D); overload;
function EquateQuadix(const x1, y1, x2, y2, x3, y3, x4, y4: Double): TQuadix2D; overload;
function EquateQuadix(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): TQuadix3D; overload;
function EquateRectangle(const x1, y1, x2, y2: Double): TRectangle;
function EquateTriangle(const x1, y1, x2, y2, x3, y3: Double): TTriangle2D; overload;
function EquateTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TTriangle3D; overload;
function EquateTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): TTriangle2D; overload;
function EquateTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): TTriangle3D; overload;
function EquateCircle(const x, y, r: Double): TCircle;
function EquateSphere(const x, y, z, r: Double): TSphere;
function EquatePlane(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TPlane2D; overload;
function EquatePlane(const Pnt1, Pnt2, Pnt3: TPoint3D): TPlane2D; overload;
procedure GenerateRandomPoints(const Bx1, By1, Bx2, By2: Double; out Point: array of TPoint2D);
function Add(const Vec1, Vec2: TVector2D): TVector2D; overload;
function Add(const Vec1, Vec2: TVector3D): TVector3D; overload;
function Add(const Vec: TVector2DArray): TVector2D; overload;
function Add(const Vec: TVector3DArray): TVector3D; overload;
function Sub(const Vec1, Vec2: TVector2D): TVector2D; overload;
function Sub(const Vec1, Vec2: TVector3D): TVector3D; overload;
function Mul(const Vec1, Vec2: TVector2D): TVector3D; overload;
function Mul(const Vec1, Vec2: TVector3D): TVector3D; overload;
function UnitVector(const Vec: TVector2D): TVector2D; overload;
function UnitVector(const Vec: TVector3D): TVector3D; overload;
function Magnitude(const Vec: TVector2D): Double; overload;
function Magnitude(const Vec: TVector3D): Double; overload;
function DotProduct(const Vec1, Vec2: TVector2D): Double; overload;
function DotProduct(const Vec1, Vec2: TVector3D): Double; overload;
function Scale(const Vec: TVector2D; const Factor: Double): TVector2D; overload;
function Scale(const Vec: TVector3D; const Factor: Double): TVector3D; overload;
function Scale(Vec: TVector2DArray; const Factor: Double): TVector2DArray; overload;
function Scale(Vec: TVector3DArray; const Factor: Double): TVector3DArray; overload;
function Negate(const Vec: TVector2D): TVector2D; overload;
function Negate(const Vec: TVector3D): TVector3D; overload;
function Negate(Vec: TVector2DArray): TVector2DArray; overload;
function Negate(Vec: TVector3DArray): TVector3DArray; overload;

function IsEqual(const Val1, Val2, Epsilon: Double): Boolean; overload;
function IsEqual(const Pnt1, Pnt2: TPoint2D; const Epsilon: Double): Boolean; overload;
function IsEqual(const Pnt1, Pnt2: TPoint3D; const Epsilon: Double): Boolean; overload;
function IsEqual(const Val1, Val2: Double): Boolean; overload;
function IsEqual(const Pnt1, Pnt2: TPoint2D): Boolean; overload;
function IsEqual(const Pnt1, Pnt2: TPoint3D): Boolean; overload;
function NotEqual(const Val1, Val2, Epsilon: Double): Boolean; overload;
function NotEqual(const Pnt1, Pnt2: TPoint2D; const Epsilon: Double): Boolean; overload;
function NotEqual(const Pnt1, Pnt2: TPoint3D; const Epsilon: Double): Boolean; overload;
function NotEqual(const Val1, Val2: Double): Boolean; overload;
function NotEqual(const Pnt1, Pnt2: TPoint2D): Boolean; overload;
function NotEqual(const Pnt1, Pnt2: TPoint3D): Boolean; overload;
function LessThanOrEqual(const Val1, Val2, Epsilon: Double): Boolean; overload;
function LessThanOrEqual(const Val1, Val2: Double): Boolean; overload;
function GreaterThanOrEqual(const Val1, Val2, Epsilon: Double): Boolean; overload;
function GreaterThanOrEqual(const Val1, Val2: Double): Boolean; overload;
function IsEqualZero(const Val, Epsilon: Double): Boolean; overload;
function IsEqualZero(const Val: Double): Boolean; overload;

function CalculateSystemEpsilon: Double;
function ZeroEquivalency: Boolean;

const EinGrad = 111.136; // [km]
const PI2 = 6.283185307179586476925286766559000;
const PIDiv180 = 0.017453292519943295769236907684886;
const _180DivPI = 57.295779513082320876798154814105000;
const Epsilon_High = 1.0E-16;
const Epsilon_Medium = 1.0E-12;
const Epsilon_Low = 1.0E-08;
const Epsilon = Epsilon_Medium;
const Infinity = 1E300;
var
  SystemEpsilon: Double;
 (* 2D/3D Portal Definition *)
  MaximumX: Double;
  MinimumX: Double;
  MaximumY: Double;
  MinimumY: Double;
  MaximumZ: Double;
  MinimumZ: Double;

  SinTable: array of Double;
  CosTable: array of Double;
  TanTable: array of Double;
procedure InitialiseTrigonometryTables;

//AF
function center(const r: TRectangle): TPoint2D;
function km(const d: double): double;
//AF

implementation

uses Math;

function Orientation(const x1, y1, x2, y2, Px, Py: Double): Integer;
var Orin: Double;
begin
 (* Linear determinant of the 3 points *)
  Orin := (x2 - x1) * (py - y1) - (px - x1) * (y2 - y1);
  if Orin > 0.0 then
    Result := +1 (* Orientaion is to the right-hand side *)
  else if Orin < 0.0 then
    Result := -1 (* Orientaion is to the left-hand side  *)
  else
    Result := 0; (* Orientaion is neutral aka collinear  *)
end;
(* End Of Orientation *)

function Orientation(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: Double): Integer;
var Px1, Px2, Px3: Double;
  Py1, Py2, Py3: Double;
  Pz1, Pz2, Pz3: Double;
  Orin: Double;
begin
  Px1 := x1 - px;
  Px2 := x2 - px;
  Px3 := x3 - px;
  Py1 := y1 - py;
  Py2 := y2 - py;
  Py3 := y3 - py;
  Pz1 := z1 - pz;
  Pz2 := z2 - pz;
  Pz3 := z3 - pz;
  Orin := Px1 * (Py2 * Pz3 - Pz2 * Py3) +
    Px2 * (Py3 * Pz1 - Pz3 * Py1) +
    Px3 * (Py1 * Pz2 - Pz1 * Py2);
  if Orin < 0.0 then
    Result := -1 (* Orientaion is below plane                      *)
  else if Orin > 0.0 then
    Result := +1 (* Orientaion is above plane                      *)
  else
    Result := 0; (* Orientaion is coplanar to plane if result is 0 *)
end;
(* End Of Orientation *)

function Orientation(const Pnt1, Pnt2: TPoint2D; const Px, Py: Double): Integer;
begin
  Result := Orientation(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Px, Py);
end;
(* End Of Orientation *)

function Orientation(const Pnt1, Pnt2, Pnt3: TPoint2D): Integer;
begin
  Result := Orientation(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of Orientation *)

function Orientation(const Ln: TLine2D; const Pnt: TPoint2D): Integer;
begin
  Result := Orientation(Ln[1].x, Ln[1].y, Ln[2].x, Ln[2].y, Pnt.x, Pnt.y);
end;
(* End Of Orientation *)

function Orientation(const Seg: TSegment2D; const Pnt: TPoint2D): Integer;
begin
  Result := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Pnt.x, Pnt.y);
end;
(* End Of Orientation *)

function Orientation(const Pnt1, Pnt2, Pnt3: TPoint3D; const Px, Py, Pz: Double): Integer;
begin
  Result := Orientation(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z, Px, Py, Pz);
end;
(* End Of Orientation *)

function Orientation(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Integer;
begin
  Result := Orientation(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z, Pnt4.x, Pnt4.y, Pnt4.z);
end;
(* End Of Orientation *)

function Orientation(const Tri: TTriangle3D; const Pnt: TPoint3D): Integer;
begin
  Result := Orientation(Tri[1], Tri[2], Tri[3], Pnt);
end;
(* End Of Orientation *)

function Signed(const x1, y1, x2, y2, Px, Py: Double): Double;
begin
  Result := (x2 - x1) * (py - y1) - (px - x1) * (y2 - y1);
end;
(* End Of Signed *)

function Signed(const x1, y1, z1, x2, y2, z2, x3, y3, z3, Px, Py, Pz: Double): Double;
var Px1, Px2, Px3: Double;
  Py1, Py2, Py3: Double;
  Pz1, Pz2, Pz3: Double;
begin
  Px1 := x1 - px;
  Px2 := x2 - px;
  Px3 := x3 - px;
  Py1 := y1 - py;
  Py2 := y2 - py;
  Py3 := y3 - py;
  Pz1 := z1 - pz;
  Pz2 := z2 - pz;
  Pz3 := z3 - pz;
  Result := Px1 * (Py2 * Pz3 - Pz2 * Py3) +
    Px2 * (Py3 * Pz1 - Pz3 * Py1) +
    Px3 * (Py1 * Pz2 - Pz1 * Py2);
end;
(* End Of Signed *)

function Signed(const Pnt1, Pnt2: TPoint2D; const Px, Py: Double): Double;
begin
  Result := Signed(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Px, Py);
end;
(* End Of Signed *)

function Signed(const Pnt1, Pnt2, Pnt3: TPoint2D): Double;
begin
  Result := Signed(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of Signed *)

function Signed(const Ln: TLine2D; const Pnt: TPoint2D): Double;
begin
  Result := Signed(Ln[1].x, Ln[1].y, Ln[2].x, Ln[2].y, Pnt.x, Pnt.y);
end;
(* End Of Signed *)

function Signed(const Seg: TSegment2D; const Pnt: TPoint2D): Double;
begin
  Result := Signed(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Pnt.x, Pnt.y);
end;
(* End Of Signed *)

function Signed(const Pnt1, Pnt2, Pnt3: TPoint3D; const Px, Py, Pz: Double): Double;
begin
  Result := Signed(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z, Px, Py, Pz);
end;
(* End Of Signed *)

function Signed(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Double;
begin
  Result := Signed(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z, Pnt4.x, Pnt4.y, Pnt4.z);
end;
(* End Of Signed *)

function Signed(const Tri: TTriangle3D; const Pnt: TPoint3D): Double;
begin
  Result := Signed(Tri[1], Tri[2], Tri[3], Pnt);
end;
(* End Of Signed *)

function Collinear(const x1, y1, x2, y2, x3, y3: Double): Boolean;
begin
 //Result := IsEqual((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1),0.0);
  Result := IsEqual((x2 - x1) * (y3 - y1), (x3 - x1) * (y2 - y1));
end;
(* End Of Collinear *)

function Collinear(const x1, y1, x2, y2, x3, y3, Epsilon: Double): Boolean;
begin
 //Result := IsEqual((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1),0.0,Epsilon);
  Result := IsEqual((x2 - x1) * (y3 - y1), (x3 - x1) * (y2 - y1), Epsilon);
end;

function Collinear(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var Dx1, Dx2: Double;
  Dy1, Dy2: Double;
  Dz1, Dz2: Double;
  Cx, Cy, Cz: Double;
//var AB,AC,BC:Double;
begin
 {find the difference between the 2 points P2 and P3 to P1 }
  Dx1 := x2 - x1;
  Dy1 := y2 - y1;
  Dz1 := z2 - z1;
  Dx2 := x3 - x1;
  Dy2 := y3 - y1;
  Dz2 := z3 - z1;
 {perform a 3d cross product}
  Cx := (Dy1 * Dz2) - (Dy2 * Dz1);
  Cy := (Dx2 * Dz1) - (Dx1 * Dz2);
  Cz := (Dx1 * Dy2) - (Dx2 * Dy1);
  Result := IsEqual(Cx * Cx + Cy * Cy + Cz * Cz, 0.0);
 {
   Note:
     The method below is very stable and logical, however at the same time
     it is "VERY" inefficient, it requires 3 SQRTs which is not acceptable...
  Result := False;
  AB := Distance(x1,y1,z1,x2,y2,z2);
  AC := Distance(x1,y1,z1,x3,y3,z3);
  BC := Distance(x2,y2,z2,x3,y3,z3);
  if (AB + AC) = BC then
   Result:=True
  else if (AB + BC) = AC then
   Result:=True
  else if (AC + BC) = AB then
   Result:=True;
 }
end;
(* End Of Collinear *)

function Collinear(const PntA, PntB, PntC: TPoint2D): Boolean;
begin
  Result := Collinear(PntA.x, PntA.y, PntB.x, PntB.y, PntC.x, PntC.y);
end;
(* End Of Collinear *)

function Collinear(const PntA, PntB, PntC: TPoint3D): Boolean;
begin
  Result := Collinear(PntA.x, PntA.y, PntA.z, PntB.x, PntB.y, PntB.z, PntC.x, PntC.y, PntC.z);
end;
(* End Of Collinear *)

function Coplanar(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean;
begin
  Result := (Orientation(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4) = 0);
end;
(* End Of Coplanar *)

function Coplanar(const PntA, PntB, PntC, PntD: TPoint3D): Boolean;
begin
  Result := (Orientation(PntA, PntB, PntC, PntD) = 0);
end;
(* End Of Coplanar *)

function IsPointCollinear(const x1, y1, x2, y2, Px, Py: Double): Boolean;
var MinX, MinY: Double;
  MaxX, MaxY: Double;
begin
 {
  This method will return true iff the point (px,py) is collinear
  to points (x1,y1) and (x2,y2) and exists on the segment A(x1,y1)->B(x2,y2)
 }
  Result := False;
  if x1 < x2 then
  begin
    MinX := x1;
    MaxX := x2;
  end
  else
  begin
    MinX := x2;
    MaxX := x1;
  end;
  if (MinX > Px) or (Px > MaxX) then Exit;
  if y1 < y2 then
  begin
    MinY := y1;
    MaxY := y2;
  end
  else
  begin
    MinY := y2;
    MaxY := y1;
  end;
  if LessThanOrEqual(MinY, Py) and LessThanOrEqual(Py, Maxy) then
  begin
    if Collinear(x1, y1, x2, y2, Px, Py) then
      Result := true;
  end;
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const PntA, PntB, PntC: TPoint2D): Boolean;
begin
 {
  This method will return true iff the pointC is collinear
  to points A and B and exists on the segment A->B or B->A
 }
  Result := IsPointCollinear(PntA.x, PntA.y, PntB.x, PntB.y, PntC.x, PntC.y);
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const PntA, PntB: TPoint2D; const Px, Py: Double): Boolean;
begin
  Result := IsPointCollinear(PntA.x, PntA.y, PntB.x, PntB.y, Px, Py);
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const Segment: TSegment2D; const PntC: TPoint2D): Boolean;
begin
  Result := IsPointCollinear(Segment[1], Segment[2], PntC);
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const x1, y1, z1, x2, y2, z2, Px, Py, Pz: Double): Boolean;
var MinX, MinY, MinZ: Double;
  MaxX, MaxY, MaxZ: Double;
begin
 {
  This method will return true iff the pointC is collinear
  to points A and B and exists on the segment A->B or B->A
 }
  Result := False;
  if x1 < x2 then
  begin
    MinX := x1;
    MaxX := x2;
  end
  else
  begin
    MinX := x2;
    MaxX := x1;
  end;
  if (MinX > Px) or (Px > MaxX) then Exit;
  if y1 < y2 then
  begin
    MinY := y1;
    MaxY := y2;
  end
  else
  begin
    MinY := y2;
    MaxY := y1;
  end;
  if (MinY > Py) or (Py > MaxY) then Exit;
  if z1 < z2 then
  begin
    MinZ := z1;
    MaxZ := z2;
  end
  else
  begin
    MinZ := z2;
    MaxZ := z1;
  end;
  if (IsEqual(MinZ, Pz) or (MinZ < Pz)) and (IsEqual(Pz, MaxZ) or (Pz < MaxZ)) then
  begin
    if Collinear(x1, y1, z1, x2, y2, z2, Px, Py, Pz) then
      Result := true;
  end;
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const PntA, PntB, PntC: TPoint3D): Boolean;
begin
  Result := IsPointCollinear(PntA.x, PntA.y, PntA.z, PntB.x, PntB.y, PntB.z, PntC.x, PntC.y, PntC.z);
end;
(* End Of IsPointCollinear *)

function IsPointCollinear(const Segment: TSegment3D; const PntC: TPoint3D): Boolean;
begin
  Result := IsPointCollinear(Segment[1], Segment[2], PntC);
end;
(* End Of IsPointCollinear *)

function IsPointOnRightSide(const x, y: Double; const Seg: TSegment2D): Boolean;
begin
  Result := (Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, x, y) < 0);
end;
(* End Of IsPointOnRightSide *)

function IsPointOnRightSide(const Pnt: TPoint2D; const Seg: TSegment2D): Boolean;
begin
  Result := (Orientation(Seg, Pnt) < 0);
end;
(* End Of IsPointOnRightSide *)

function IsPointOnRightSide(const x, y: Double; const Ln: TLine2D): Boolean;
begin
  Result := (Orientation(Ln[1].x, Ln[1].y, Ln[2].x, Ln[2].y, x, y) < 0);
end;
(* End Of IsPointOnRightSide *)

function IsPointOnRightSide(const Pnt: TPoint2D; const Ln: TLine2D): Boolean;
begin
  Result := (Orientation(Ln, Pnt) < 0);
end;
(* End Of IsPointOnRightSide *)

function IsPointOnLeftSide(const x, y: Double; const Seg: TSegment2D): Boolean;
begin
  Result := (Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, x, y) > 0);
end;
(* End Of IsPointOnLeftSide *)

function IsPointOnLeftSide(const Pnt: TPoint2D; const Seg: TSegment2D): Boolean;
begin
  Result := (Orientation(Seg, Pnt) > 0);
end;
(* End Of IsPointOnLeftSide *)

function IsPointOnLeftSide(const x, y: Double; const Ln: TLine2D): Boolean;
begin
  Result := (Orientation(Ln[1].x, Ln[1].y, Ln[2].x, Ln[2].y, x, y) > 0);
end;
(* End Of IsPointOnLeftSide *)

function IsPointOnLeftSide(const Pnt: TPoint2D; const Ln: TLine2D): Boolean;
begin
  Result := (Orientation(Ln, Pnt) > 0);
end;
(* End Of IsPointOnLeftSide *)

function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
var UpperX: Double;
  UpperY: Double;
  LowerX: Double;
  LowerY: Double;
  Ax: Double;
  Bx: Double;
  Cx: Double;
  Ay: Double;
  By: Double;
  Cy: Double;
  D: Double;
  F: Double;
  E: Double;
begin
  Result := false;
  Ax := x2 - x1;
  Bx := x3 - x4;
  if Ax < 0.0 then
  begin
    LowerX := x2;
    UpperX := x1;
  end
  else
  begin
    UpperX := x2;
    LowerX := x1;
  end;
  if Bx > 0.0 then
  begin
    if (UpperX < x4) or (x3 < LowerX) then
      Exit;
  end
  else if (Upperx < x3) or (x4 < LowerX) then
    Exit;
  Ay := y2 - y1;
  By := y3 - y4;
  if Ay < 0.0 then
  begin
    LowerY := y2;
    UpperY := y1;
  end
  else
  begin
    UpperY := y2;
    LowerY := y1;
  end;
  if By > 0.0 then
  begin
    if (UpperY < y4) or (y3 < LowerY) then
      Exit;
  end
  else if (UpperY < y3) or (y4 < LowerY) then
    Exit;
  Cx := x1 - x3;
  Cy := y1 - y3;
  d := (By * Cx) - (Bx * Cy);
  f := (Ay * Bx) - (Ax * By);
  if f > 0.0 then
  begin
    if (d < 0.0) or (d > f) then
      Exit;
  end
  else if (d > 0.0) or (d < f) then
    Exit;
  e := (Ax * Cy) - (Ay * Cx);
  if f > 0.0 then
  begin
    if (e < 0.0) or (e > f) then
      Exit;
  end
  else if (e > 0.0) or (e < f) then
    Exit;
  Result := true;
 (*
   Simple method, yet not so accurate for certain situations:
   Result := (Orientation(x1,y1,x2,y2,x3,y3) <> Orientation(x1,y1,x2,y2,x4,y4)) and
             (Orientation(x3,y3,x4,y4,x1,y1) <> Orientation(x3,y3,x4,y4,x2,y2));
 *)
end;
(* End Of SegmentIntersect *)

function Intersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double; out ix, iy: Double): Boolean;
var UpperX: Double;
  UpperY: Double;
  LowerX: Double;
  LowerY: Double;
  Ax: Double;
  Bx: Double;
  Cx: Double;
  Ay: Double;
  By: Double;
  Cy: Double;
  D: Double;
  F: Double;
  E: Double;
  Ratio: Double;
begin
  Result := false;
  Ax := x2 - x1;
  Bx := x3 - x4;
  if Ax < 0.0 then
  begin
    LowerX := x2;
    UpperX := x1;
  end
  else
  begin
    UpperX := x2;
    LowerX := x1;
  end;
  if Bx > 0.0 then
  begin
    if (UpperX < x4) or (x3 < LowerX) then
      Exit;
  end
  else if (Upperx < x3) or (x4 < LowerX) then
    Exit;
  Ay := y2 - y1;
  By := y3 - y4;
  if Ay < 0.0 then
  begin
    LowerY := y2;
    UpperY := y1;
  end
  else
  begin
    UpperY := y2;
    LowerY := y1;
  end;
  if By > 0.0 then
  begin
    if (UpperY < y4) or (y3 < LowerY) then
      Exit;
  end
  else if (UpperY < y3) or (y4 < LowerY) then
    Exit;
  Cx := x1 - x3;
  Cy := y1 - y3;
  d := (By * Cx) - (Bx * Cy);
  f := (Ay * Bx) - (Ax * By);
  if f > 0.0 then
  begin
    if (d < 0.0) or (d > f) then
      Exit;
  end
  else if (d > 0.0) or (d < f) then
    Exit;
  e := (Ax * Cy) - (Ay * Cx);
  if f > 0.0 then
  begin
    if (e < 0.0) or (e > f) then
      Exit;
  end
  else if (e > 0.0) or (e < f) then
    Exit;
  Result := true;

  (*
    From IntersectionPoint Routine
    dx1 := x2 - x1; ->  Ax
    dx2 := x4 - x3; -> -Bx
    dx3 := x1 - x3; ->  Cx
    dy1 := y2 - y1; ->  Ay
    dy2 := y1 - y3; ->  Cy
    dy3 := y4 - y3; -> -By
  *)
  Ratio := (Ax * -By) - (Ay * -Bx);
  if NotEqual(Ratio, 0.0) then
  begin
    Ratio := ((Cy * -Bx) - (Cx * -By)) / Ratio;
    ix := x1 + (Ratio * Ax);
    iy := y1 + (Ratio * Ay);
  end
  else
  begin
   //if Collinear(x1,y1,x2,y2,x3,y3) then
    if IsEqual((Ax * -Cy), (-Cx * Ay)) then
    begin
      ix := x3;
      iy := y3;
    end
    else
    begin
      ix := x4;
      iy := y4;
    end;
  end;
end;
(* End Of SegmentIntersect *)

function Intersect(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean;
begin
  Result := Intersect(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Pnt4.x, Pnt4.y);
end;
(* End Of Intersect *)

function Intersect(const Seg1, Seg2: TSegment2D): Boolean;
begin
  Result := Intersect(Seg1[1], Seg1[2], Seg2[1], Seg2[2]);
end;
(* End Of Intersect *)

function Intersect(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean;
var
  p13: TPoint3D;
  p43: TPoint3D;
  p21: TPoint3D;
  d4321: Double;
  d4343: Double;
  d2121: Double;
begin
  Result := True;
  p13.x := x1 - x3;
  p13.y := y1 - y3;
  p13.z := z1 - z3;
  p43.x := x4 - x3;
  p43.y := y4 - y3;
  p43.z := z4 - z3;
  if IsEqual(abs(p43.x), 0.0) and
    IsEqual(abs(p43.y), 0.0) and
    IsEqual(abs(p43.z), 0.0) then Exit;
  p21.x := x2 - x1;
  p21.y := y2 - y1;
  p21.z := z2 - z1;
  if IsEqual(abs(p21.x), 0.0) and
    IsEqual(abs(p21.y), 0.0) and
    IsEqual(abs(p21.z), 0.0) then Exit;
  d4321 := p43.x * p21.x + p43.y * p21.y + p43.z * p21.z;
  d4343 := p43.x * p43.x + p43.y * p43.y + p43.z * p43.z;
  d2121 := p21.x * p21.x + p21.y * p21.y + p21.z * p21.z;
  if IsEqual(d2121 * d4343 - d4321 * d4321, 0.0) then Exit;
  Result := False;
end;
(* End Of Intersect *)

function Intersect(const P1, P2, P3, P4: TPoint3D): Boolean;
begin
  Result := Intersect(P1.x, P1.y, P1.z, P2.x, P2.y, P2.z, P3.x, P3.y, P3.z, P4.x, P4.y, P4.z);
end;
(* End Of Intersect *)

function Intersect(const Seg1, Seg2: TSegment3D): Boolean;
begin
  Result := Intersect(Seg1[1], Seg1[2], Seg2[1], Seg2[2]);
end;
(* End Of Intersect *)

function Intersect(const Seg: TSegment2D; const Rec: TRectangle): Boolean;
var P1: Boolean;
  P2: Boolean;
  CO: Double;
  PO: Double;
begin
  P1 := PointInRectangle(Seg[1], Rec);
  P2 := PointInRectangle(Seg[2], Rec);
 {
   if both points lie within the rectangle
 }
  Result := False;
  if P1 and P2 then Exit;
 {
   if one of the points lies within the rectangle and the
   other outside of the rectangle
 }
  Result := True;
  if P1 <> P2 then Exit;
 {
   if both points lie outside the rectangle, and a constant
   orientation is encounrted, it can then be assumed that
   the segment does not intersect the rectangle.
 }
  PO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Rec[1].x, Rec[1].y);
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Rec[2].x, Rec[1].y);
  if CO <> PO then Exit;
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Rec[2].x, Rec[2].y);
  if CO <> PO then Exit;
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Rec[1].x, Rec[2].y);
  if CO <> PO then Exit;
  Result := False;
end;
(* End Of Intersect *)

function Intersect(const Seg: TSegment2D; const Tri: TTriangle2D): Boolean;
var P1, P2: Boolean;
  CO, PO: Double;
begin
  Result := False;
  P1 := PointInTriangle(Seg[1], Tri);
  P2 := PointInTriangle(Seg[2], Tri);
 {
  if both points lie within the triangle
 }
  if P1 and P2 then Exit;

 {
   if one of the points lies within the triangle and the
   other outside of the rectangle
 }
  Result := True;
  if P1 <> P2 then Exit;

 {
   if both points lie outside the triangle, and a constant
   orientation is encountered, it can then be assumed that
   the segment does not intersect the triangle.
   Hence a test for continual constant orientation is done.
 }
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Tri[1].x, Tri[1].y);
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Tri[2].x, Tri[2].y);
  if CO <> PO then Exit;
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Tri[3].x, Tri[3].y);
  if CO <> PO then Exit;
  Result := False;
end;
(* End Of Intersect *)

function Intersect(const Seg: TSegment2D; const Quad: TQuadix2D): Boolean;
var P1, P2: Boolean;
  CO, PO: Double;
begin
  P1 := PointInQuadix(Seg[1], Quad);
  P2 := PointInQuadix(Seg[2], Quad);
 {
  if both points lie within the Quadix
 }
  Result := False;
  if P1 and P2 then Exit;
 {
   if one of the points lies within the quadix and the
   other outside of the quadix
 }
  Result := True;
  if P1 <> P2 then Exit;

 {
   At this point it is assumed both points lie outside of
   the quadix.
   if both points lie outside the quadix, and a constant
   orientation is encountered, it can then be assumed that
   the segment does not intersect the quadix.
   Hence a test for continual orientation is done.
 }
  Result := True;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Quad[1].x, Quad[1].y);
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Quad[2].x, Quad[2].y);
  if CO <> PO then Exit;
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Quad[3].x, Quad[3].y);
  if CO <> PO then Exit;
  PO := CO;
  CO := Orientation(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Quad[4].x, Quad[4].y);
  if CO <> PO then Exit;
 {
  Reaching this point means that the segment is actually outside
  of the quadix and is not intersecting with any of the edges.
 }
  Result := False;
end;
(* End Of Intersect *)

function Intersect(Seg: TSegment2D; const Cir: TCircle): Boolean;
begin
 (*
  It is assumed that an intersection by a segment is either
  a full (2 points) partial (1 point) or tangential. Anything
  else will result in a false output.
 *)
  Seg := Translate(-Cir.x, -Cir.y, Seg);
 //Result := (((Cir.Radius * Cir.Radius) * LayDistance(Seg) - Sqr(Seg[1].x * Seg[2].y - Seg[2].x * Seg[1].y)) >= 0.0);
  Result := GreaterThanOrEqual(((Cir.Radius * Cir.Radius) * LayDistance(Seg) - Sqr(Seg[1].x * Seg[2].y - Seg[2].x * Seg[1].y)), 0.0)
end;
(* End Of Intersect *)

function Intersect(const Seg: TSegment3D; const Sphere: TSphere): Boolean;
var A: Double;
  B: Double;
  C: Double;
begin
  A := LayDistance(Seg);
  B := 2 * ((Seg[2].x - Seg[1].x) * (Seg[1].x - Sphere.x) + (Seg[2].y - Seg[1].y) * (Seg[1].y - Sphere.y) + (Seg[2].z - Seg[1].z) * (Seg[1].z - Sphere.z));
  C := Sqr(Sphere.x) + Sqr(Sphere.y) + Sqr(Sphere.z) + Sqr(Seg[1].x) + Sqr(Seg[1].y) + Sqr(Seg[1].z) - 2 * (Sphere.x * Seg[1].x + Sphere.y * Seg[1].y + Sphere.z * Seg[1].z) - Sqr(Sphere.Radius);
 //Result:=((B * B - 4 * A * C) >= 0)
  Result := GreaterThanOrEqual((B * B - 4 * A * C), 0.0)
end;
(* End Of Intersect *)

function Intersect(const Line: TLine3D; const Triangle: TTriangle3D; out IPoint: TPoint3D): Boolean;
var u: TVector3D;
  v: TVector3D;
  n: TVector3D;
  dir: TVector3D;
  w0: TVector3D;
  w: TVector3D;
  a: Double;
  b: Double;
  r: Double;
  uu: Double;
  uv: Double;
  vv: Double;
  wu: Double;
  wv: Double;
  d: Double;
  s: Double;
  t: Double;
begin
  Result := False;
  u.x := Triangle[2].x - Triangle[1].x;
  u.y := Triangle[2].y - Triangle[1].y;
  u.z := Triangle[2].z - Triangle[1].z;
  v.x := Triangle[3].x - Triangle[1].x;
  v.y := Triangle[3].y - Triangle[1].y;
  v.z := Triangle[3].z - Triangle[1].z;
  n := Mul(u, v);
  if IsEqual(DotProduct(u, n), 0.0) then
  begin
   (*
      The triangle is degenerate, ie: vertices are all
      collinear to each other and/or not unique.
   *)
    Exit;
  end;
  dir.x := Line[2].x - Line[1].x;
  dir.y := Line[2].y - Line[1].y;
  dir.z := Line[2].z - Line[1].z;
  w0.x := Line[1].x - Triangle[1].x;
  w0.y := Line[1].y - Triangle[1].y;
  w0.z := Line[1].z - Triangle[1].z;
  a := DotProduct(n, w0) * -1.0;
  b := DotProduct(n, dir);
  if IsEqual(Abs(b), 0.0) then
  begin
    Exit;
  (*
     A further test can be done to determine if the
     ray is coplanar to the triangle.
     In any case the test for unique point intersection
     has failed.
    if IsEqual(a,0.0) then  ray is coplanar to triangle
  *)
  end;
  r := a / b;
  if IsEqual(r, 0.0) then
  begin
    Exit;
  end;
  IPoint.x := Line[1].x + (r * dir.x);
  IPoint.y := Line[1].y + (r * dir.y);
  IPoint.z := Line[1].z + (r * dir.z);
  w.x := IPoint.x - Triangle[1].x;
  w.y := IPoint.y - Triangle[1].y;
  w.z := IPoint.z - Triangle[1].z;
  uu := DotProduct(u, u);
  uv := DotProduct(u, v);
  vv := DotProduct(v, v);
  wu := DotProduct(w, u);
  wv := DotProduct(w, v);
  d := uv * uv - uu * vv;
 // get and test parametric coords
  s := ((uv * wv) - (vv * wu)) / d;
  if (s < 0.0) or (s > 1.0) then
  begin
  (*
     Intersection is outside of triangle
  *)
    Exit;
  end;
  t := ((uv * wu) - (uu * wv)) / d;
  if (t < 0.0) or ((s + t) > 1.0) then
  begin
  (*
     Intersection is outside of triangle
  *)
    Exit;
  end;
  Result := True;
end;
(* End Of Intersect *)

procedure IntersectionPoint(const x1, y1, x2, y2, x3, y3, x4, y4: Double; out Nx, Ny: Double);
var
  Ratio: Double;
  dx1, dx2, dx3: Double;
  dy1, dy2, dy3: Double;
begin
  dx1 := x2 - x1;
  dx2 := x4 - x3;
  dx3 := x1 - x3;
  dy1 := y2 - y1;
  dy2 := y1 - y3;
  dy3 := y4 - y3;
  Ratio := dx1 * dy3 - dy1 * dx2;
  if NotEqual(Ratio, 0.0) then
  begin
    Ratio := (dy2 * dx2 - dx3 * dy3) / Ratio;
    Nx := x1 + Ratio * dx1;
    Ny := y1 + Ratio * dy1;
  end
  else
  begin
   //if Collinear(x1,y1,x2,y2,x3,y3) then
    if IsEqual((dx1 * -dy2), (-dx3 * dy1)) then
    begin
      Nx := x3;
      Ny := y3;
    end
    else
    begin
      Nx := x4;
      Ny := y4;
    end;
  end;
end;
(* End Of IntersectionPoint *)

procedure IntersectionPoint(const P1, P2, P3, P4: TPoint2D; out Nx, Ny: Double);
begin
  IntersectionPoint(P1.x, P1.y, P2.x, P2.y, P3.x, P3.y, P4.x, P4.y, Nx, Ny);
end;
(* End Of IntersectionPoint *)

function IntersectionPoint(const P1, P2, P3, P4: TPoint2D): TPoint2D;
begin
  IntersectionPoint(P1.x, P1.y, P2.x, P2.y, P3.x, P3.y, P4.x, P4.y, Result.x, Result.y);
end;
(* End Of IntersectionPoint *)

function IntersectionPoint(const Seg1, Seg2: TSegment2D): TPoint2D;
begin
  Result := IntersectionPoint(Seg1[1], Seg1[2], Seg2[1], Seg2[2]);
end;
(* End Of IntersectionPoint *)

function IntersectionPoint(const Ln1, Ln2: TLine2D): TPoint2D;
var
  dx1: Double;
  dx2: Double;
  dx3: Double;
  dy1: Double;
  dy2: Double;
  dy3: Double;
  det: Double;
  ratio: Double;
begin
  dx1 := Ln1[1].x - Ln1[2].x;
  dx2 := Ln2[1].x - Ln2[2].x;
  dx3 := Ln2[2].x - Ln1[2].x;
  dy1 := Ln1[1].y - Ln1[2].y;
  dy2 := Ln2[1].y - Ln2[2].y;
  dy3 := Ln2[2].y - Ln1[2].y;
  det := (dx2 * dy1) - (dy2 * dx1);
  if IsEqual(det, 0.0) then
  begin
    if IsEqual((dx2 * dy3), (dy2 * dx3)) then
    begin
      Result.x := Ln2[1].x;
      Result.y := Ln2[1].y;
      Exit;
    end
    else
      Exit;
  end;
  ratio := ((dx1 * dy3) - (dy1 * dx3)) / det;
  Result.x := (ratio * dx2) + Ln2[2].x;
  Result.y := (ratio * dy2) + Ln2[2].y;
end;
(* End Of IntersectionPoint *)

procedure IntersectionPoint(const Cir1, Cir2: TCircle; out Pnt1, Pnt2: TPoint2D);
var
  Dist: Double;
  A: Double;
  H: Double;
  RatioA: Double;
  RatioH: Double;
  Dx: Double;
  Dy: Double;
  Phi: TPoint2D;
begin
  Dist := Distance(Cir1, Cir2);
  A := (Dist * Dist - Cir1.Radius * Cir1.Radius - Cir2.Radius * Cir1.Radius) / (2 * Dist);
  H := Sqrt(Cir1.Radius * Cir1.Radius - A * A);
  RatioA := A / Dist;
  RatioH := H / Dist;
  Dx := Cir1.x - Cir2.x;
  Dy := Cir1.y - Cir2.y;
  Phi.x := Cir1.x + (RatioA * Dx);
  Phi.y := Cir1.y + (RatioA * Dy);
  Dx := Dx * RatioH;
  Dy := Dy * RatioH;
  Pnt1.x := Phi.x + Dx;
  Pnt1.y := Phi.y - Dy;
  Pnt2.x := Phi.x - Dx;
  Pnt2.y := Phi.y + Dy;
end;
(* End Of IntersectionPoint *)

procedure IntersectionPoint(const Line: TLine3D; const Triangle: TTriangle3D; out IPoint: TPoint3D);
var
  u: TVector3D;
  v: TVector3D;
  n: TVector3D;
  dir: TVector3D;
  w0: TVector3D;
    //w   : TVector3D;
  a: Double;
  b: Double;
  r: Double;
begin
  u.x := Triangle[2].x - Triangle[1].x;
  u.y := Triangle[2].y - Triangle[1].y;
  u.z := Triangle[2].z - Triangle[1].z;
  v.x := Triangle[3].x - Triangle[1].x;
  v.y := Triangle[3].y - Triangle[1].y;
  v.z := Triangle[3].z - Triangle[1].z;
  n := Mul(u, v);
  dir.x := Line[2].x - Line[1].x;
  dir.y := Line[2].y - Line[1].y;
  dir.z := Line[2].z - Line[1].z;
  w0.x := Line[1].x - Triangle[1].x;
  w0.y := Line[1].y - Triangle[1].y;
  w0.z := Line[1].z - Triangle[1].z;
  a := DotProduct(n, w0) * -1.0;
  b := DotProduct(n, dir);
  r := a / b;
  IPoint.x := Line[1].x + (r * dir.x);
  IPoint.y := Line[1].y + (r * dir.y);
  IPoint.z := Line[1].z + (r * dir.z);
end;
(* End Of IntersectionPoint *)

function VertexAngle(x1, y1, x2, y2, x3, y3: Double): Double;
var Dist: Double;
begin
 (* Quantify coordinates *)
  x1 := x1 - x2;
  x3 := x3 - x2;
  y1 := y1 - y2;
  y3 := y3 - y2;
 (* Calculate Lay Distance *)
  Dist := (x1 * x1 + y1 * y1) * (x3 * x3 + y3 * y3);
  if IsEqual(Dist, 0.0) then
    Result := 0.0
  else
    Result := ArcCos((x1 * x3 + y1 * y3) / (sqrt(Dist) * 1.0)) * _180DivPI
end;
(* End Of VertexAngle *)

function VertexAngle(const Pnt1, Pnt2, Pnt3: TPoint2D): Double;
begin
  Result := VertexAngle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of VertexAngle *)

function VertexAngle(x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Double;
var Dist: Double;
begin
 (* Quantify coordinates *)
  x1 := x1 - x2;
  x3 := x3 - x2;
  y1 := y1 - y2;
  y3 := y3 - y2;
  z1 := z1 - z2;
  z3 := z3 - z2;
 (* Calculate Lay Distance *)
  Dist := (x1 * x1 + y1 * y1 + z1 * z1) * (x3 * x3 + y3 * y3 + z3 * z3);
  if IsEqual(Dist, 0.0) then
    Result := 0.0
  else
    Result := ArcCos((x1 * x3 + y1 * y3 + z1 * z3) / sqrt(Dist)) * _180DivPI;
end;
(* End Of VertexAngle *)

function VertexAngle(const Pnt1, Pnt2, Pnt3: TPoint3D): Double;
begin
  Result := VertexAngle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of VertexAngle *)

function SegmentIntersectAngle(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Double;
var TempPnt: TPoint2D;
begin
  Result := -1;
  if Intersect(Pnt1, Pnt2, Pnt3, Pnt4) then
  begin
    TempPnt := IntersectionPoint(Pnt1, Pnt2, Pnt3, Pnt4);
    Result := VertexAngle(Pnt1, TempPnt, Pnt4);
  end;
end;
(* End Of SegmentIntersectAngle *)

function SegmentIntersectAngle(const Seg1, Seg2: TSegment2D): Double;
var TempPnt: TPoint2D;
begin
  Result := -1;
  if Intersect(Seg1, Seg2) then
  begin
    TempPnt := IntersectionPoint(Seg1, Seg2);
    Result := VertexAngle(Seg1[1], TempPnt, Seg2[1]);
  end;
end;
(* End Of SegmentIntersectAngle *)

function SegmentIntersectAngle(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Double;
begin
 {
  This section can be completed once line intersection in 3D is complete
 }
  Result := 0.0;
end;
(* End Of SegmentIntersectAngle *)

function SegmentIntersectAngle(const Seg1, Seg2: TSegment3D): Double;
begin
 {
  This section can be completed once line intersection in 3D is complete
 }
  Result := 0.0;
end;
(* End Of SegmentIntersectAngle *)

function InPortal(const P: TPoint2D): Boolean;
begin
  Result := PointInRectangle(P, MinimumX, MinimumY, MaximumX, MaximumY);
end;
(* End Of InPortal *)

function InPortal(const P: TPoint3D): Boolean;
begin
  Result := LessThanOrEqual(MinimumX, P.x) and LessThanOrEqual(MaximumZ, P.x) and
    LessThanOrEqual(MinimumY, P.y) and LessThanOrEqual(MaximumY, P.y) and
    LessThanOrEqual(MinimumZ, P.y) and LessThanOrEqual(MaximumZ, P.y);
end;
(* End Of InPortal *)

function HighestPoint(const Polygon: TPolygon2D): TPoint2D;
var i: Integer;
  TempPnt: TPoint2D;
begin
  TempPnt.y := MinimumY;
  for i := 0 to Length(Polygon) - 1 do
    if Polygon[i].y > TempPnt.y then
      TempPnt := Polygon[i];
  Result := TempPnt;
end;
(* End Of HighestPoint *)

function HighestPoint(const Tri: TTriangle2D): TPoint2D;
begin
  Result.y := MinimumY;
  if Tri[1].y > Result.y then
    Result := Tri[1];
  if Tri[2].y > Result.y then
    Result := Tri[2];
  if Tri[3].y > Result.y then
    Result := Tri[3];
end;
(* End Of HighestPoint *)

function HighestPoint(const Tri: TTriangle3D): TPoint3D;
begin
  Result.y := MinimumY;
  if Tri[1].y > Result.y then
    Result := Tri[1];
  if Tri[2].y > Result.y then
    Result := Tri[2];
  if Tri[3].y > Result.y then
    Result := Tri[3];
end;
(* End Of HighestPoint *)

function HighestPoint(const Quadix: TQuadix2D): TPoint2D;
begin
  Result.y := MinimumY;
  if Quadix[1].y > Result.y then
    Result := Quadix[1];
  if Quadix[2].y > Result.y then
    Result := Quadix[2];
  if Quadix[3].y > Result.y then
    Result := Quadix[3];
  if Quadix[4].y > Result.y then
    Result := Quadix[4];
end;
(* End Of HighestPoint *)

function HighestPoint(const Quadix: TQuadix3D): TPoint3D;
begin
  Result.y := MinimumY;
  if Quadix[1].y > Result.y then
    Result := Quadix[1];
  if Quadix[2].y > Result.y then
    Result := Quadix[2];
  if Quadix[3].y > Result.y then
    Result := Quadix[3];
  if Quadix[4].y > Result.y then
    Result := Quadix[4];
end;
(* End Of HighestPoint *)

function LowestPoint(const Polygon: TPolygon2D): TPoint2D;
var I: Integer;
begin
  Result.y := MaximumY;
  for I := 0 to Length(Polygon) - 1 do
    if Polygon[I].y < Result.y then
      Result := Polygon[I];
end;
(* End Of LowestPoint *)

function LowestPoint(const Tri: TTriangle2D): TPoint2D;
begin
  Result.y := MaximumY;
  if Tri[1].y < Result.y then
    Result := Tri[1];
  if Tri[2].y < Result.y then
    Result := Tri[2];
  if Tri[3].y < Result.y then
    Result := Tri[3];
end;
(* End Of LowestPoint *)

function LowestPoint(const Tri: TTriangle3D): TPoint3D;
begin
  Result.y := MaximumY;
  if Tri[1].y < Result.y then
    Result := Tri[1];
  if Tri[2].y < Result.y then
    Result := Tri[2];
  if Tri[3].y < Result.y then
    Result := Tri[3];
end;
(* End Of LowestPoint *)

function LowestPoint(const Quadix: TQuadix2D): TPoint2D;
begin
  Result.y := MinimumY;
  if Quadix[1].y > Result.y then
    Result := Quadix[1];
  if Quadix[2].y > Result.y then
    Result := Quadix[2];
  if Quadix[3].y > Result.y then
    Result := Quadix[3];
  if Quadix[4].y > Result.y then
    Result := Quadix[4];
end;
(* End Of LowestPoint *)

function LowestPoint(const Quadix: TQuadix3D): TPoint3D;
begin
  Result.y := MinimumY;
  if Quadix[1].y > Result.y then
    Result := Quadix[1];
  if Quadix[2].y > Result.y then
    Result := Quadix[2];
  if Quadix[3].y > Result.y then
    Result := Quadix[3];
  if Quadix[4].y > Result.y then
    Result := Quadix[4];
end;
(* End Of LowestPoint *)

function Coincident(const Pnt1, Pnt2: TPoint2D): Boolean;
begin
  Result := IsEqual(Pnt1, Pnt2);
end;
(* End Of Coincident - 2D Points *)

function Coincident(const Pnt1, Pnt2: TPoint3D): Boolean;
begin
  Result := IsEqual(Pnt1, Pnt2);
end;
(* End Of Coincident - 3D Points *)

function Coincident(const Seg1, Seg2: TSegment2D): Boolean;
begin
  Result := (Coincident(Seg1[1], Seg2[1]) and Coincident(Seg1[2], Seg2[2])) or
    (Coincident(Seg1[1], Seg2[2]) and Coincident(Seg1[2], Seg2[1]));
end;
(* End Of Coincident - 2D Segments *)

function Coincident(const Seg1, Seg2: TSegment3D): Boolean;
begin
  Result := (Coincident(Seg1[1], Seg2[1]) and Coincident(Seg1[2], Seg2[2])) or
    (Coincident(Seg1[1], Seg2[2]) and Coincident(Seg1[2], Seg2[1]));
end;
(* End Of Coincident - 3D Segments *)

function Coincident(const Tri1, Tri2: TTriangle2D): Boolean;
var Flag: array[1..3] of Boolean;
  Count: Integer;
  I: Integer;
  J: Integer;
begin
  Count := 0;
  for i := 1 to 3 do Flag[i] := False;
  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
      if not Flag[i] then
        if Coincident(Tri1[i], Tri2[j]) then
        begin
          Inc(Count);
          Flag[i] := True;
          Break;
        end;
  end;
  Result := (Count = 3);
end;
(* End Of Coincident - 2D Triangles *)

function Coincident(const Tri1, Tri2: TTriangle3D): Boolean;
var Flag: array[1..3] of Boolean;
  Count: Integer;
  i: Integer;
  j: Integer;
begin
  Count := 0;
  for i := 1 to 3 do Flag[i] := False;
  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
      if not Flag[i] then
        if Coincident(Tri1[i], Tri2[j]) then
        begin
          Inc(Count);
          Flag[i] := True;
          Break;
        end;
  end;
  Result := (Count = 3);
end;
(* End Of Coincident - 3D Triangles *)

function Coincident(const Rect1, Rect2: TRectangle): Boolean;
begin
  Result := Coincident(Rect1[1], Rect2[1]) and
    Coincident(Rect1[2], Rect2[2]);
end;
(* End Of Coincident - Rectangles *)

function Coincident(const Quad1, Quad2: TQuadix2D): Boolean;
var Flag: array[1..4] of Boolean;
  Count: Integer;
  I: Integer;
  J: Integer;
begin
  Result := False;
  if ConvexQuadix(Quad1) <> ConvexQuadix(Quad2) then Exit;
  Count := 0;
  for i := 1 to 4 do Flag[I] := False;
  for i := 1 to 4 do
  begin
    for j := 1 to 4 do
      if not Flag[i] then
        if Coincident(Quad1[i], Quad2[j]) then
        begin
          Inc(Count);
          Flag[i] := True;
          Break;
        end;
  end;
  Result := (Count = 4);
end;
(* End Of Coincident - 2D Quadii *)

function Coincident(const Quad1, Quad2: TQuadix3D): Boolean;
begin
 (* To be implemented at a later date *)
  Result := False;
end;
(* End Of Coincident - 3D Quadii *)

function Coincident(const Cir1, Cir2: TCircle): Boolean;
begin
  Result := IsEqual(Cir1.x, Cir2.x) and
    IsEqual(Cir1.y, Cir2.y) and
    IsEqual(Cir1.Radius, Cir2.Radius);
end;
(* End Of Coincident - Circles *)

function Coincident(const Sphr1, Sphr2: TSphere): Boolean;
begin
  Result := IsEqual(Sphr1.x, Sphr2.x) and
    IsEqual(Sphr1.y, Sphr2.y) and
    IsEqual(Sphr1.z, Sphr2.z) and
    IsEqual(Sphr1.Radius, Sphr2.Radius);
end;
(* End Of Coincident - Spheres *)

procedure PerpendicularPntToSegment(const x1, y1, x2, y2, Px, Py: Double; out Nx, Ny: Double);
var Ratio: Double;
  Dx: Double;
  Dy: Double;
begin
  Dx := x2 - x1;
  Dy := y2 - y1;
  Ratio := ((Px - x1) * Dx + (Py - y1) * Dy) / (Dx * Dx + Dy * Dy);
  if Ratio < 0.0 then
  begin
    Nx := x1;
    Ny := y1;
  end
  else if Ratio > 1.0 then
  begin
    Nx := x2;
    Ny := y2;
  end
  else
  begin
    Nx := x1 + (Ratio * Dx);
    Ny := y1 + (Ratio * Dy);
  end;
end;
(* End PerpendicularPntSegment *)

function PerpendicularPntToSegment(const Seg: TSegment2D; const Pnt: TPoint2D): TPoint2D;
begin
  PerpendicularPntToSegment(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Pnt.x, Pnt.y, Result.x, Result.y);
end;
(* End PerpendicularPntSegment *)

procedure PerpendicularPntToSegment(const x1, y1, z1, x2, y2, z2, Px, Py, Pz: Double; out Nx, Ny, Nz: Double);
var Ratio: Double;
  Dx: Double;
  Dy: Double;
  Dz: Double;
begin
  Dx := x2 - x1;
  Dy := y2 - y1;
  Dz := z2 - z2;
  Ratio := (((Px - x1) * Dx) + ((Py - y1) * Dy) + ((Pz - z1) * Dz)) / (Dx * Dx + Dy * Dy + Dz * Dz);
  if Ratio < 0.0 then
  begin
    Nx := x1;
    Ny := y1;
    Nz := z1;
  end
  else if Ratio > 1.0 then
  begin
    Nx := x2;
    Ny := y2;
    Nz := z2;
  end
  else
  begin
    Nx := x1 + (Ratio * Dx);
    Ny := y1 + (Ratio * Dy);
    Nz := z1 + (Ratio * Dz);
  end;
end;
(* End PerpendicularPntSegment *)

function PerpendicularPntToSegment(const Seg: TSegment3D; const Pnt: TPoint3D): TPoint3D;
begin
  PerpendicularPntToSegment(Seg[1].x, Seg[1].y, Seg[1].z, Seg[2].x, Seg[2].y, Seg[2].z, Pnt.x, Pnt.y, Pnt.z, Result.x, Result.y, Result.z);
end;
(* End PerpendicularPntSegment *)

procedure PerpendicularPntToRay(const Rx1, Ry1, Rx2, Ry2, Px, Py: Double; out Nx, Ny: Double);
var
  Ratio: Double;
  Gr1, Gr2: Double;
  Gr3, Gr4: Double;
begin
 (*  The ray is defined by the coordinate pairs (Rx1,Ry1) and (Rx2,Ry2) *)
  if NotEqual(Rx1, Rx2) then
    Gr1 := (Ry2 - Ry1) / (Rx2 - Rx1)
  else
    Gr1 := 1E300;
  Gr3 := Ry1 - Gr1 * Rx1;
  if NotEqual(Gr1, 0.0) then
  begin
    Gr2 := -1 / Gr1;
    Gr4 := Py - (Gr2 * Px);
    Ratio := (Gr4 - Gr3) / (Gr1 - Gr2);
    Nx := Ratio;
    Ny := (Gr2 * Ratio) + Gr4;
  end
  else
  begin
    Nx := Px;
    Ny := Ry2;
  end;
end;
(* End PerpendicularPntToRay *)

function PerpendicularPntToRay(const Seg: TSegment2D; const Pnt: TPoint2D): TPoint2D;
begin
 (* The ray is defined by the segment *)
  PerpendicularPntToRay(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Pnt.x, Pnt.y, Result.x, Result.y);
end;
(* End PerpendicularPntSegment *)

function PointToSegmentDistance(const Px, Py, x1, y1, x2, y2: Double): Double;
var Ratio: Double;
  Dx: Double;
  Dy: Double;
begin
  if IsEqual(x1, x2) and IsEqual(y1, y2) then
  begin
    Result := Distance(Px, Py, x1, y1);
  end
  else
  begin
    Dx := x2 - x1;
    Dy := y2 - y1;
    Ratio := ((Px - x1) * Dx + (Py - y1) * Dy) / (Dx * Dx + Dy * Dy);
    if Ratio < 0.0 then
      Result := Distance(Px, Py, x1, y1)
    else if Ratio > 1.0 then
      Result := Distance(Px, Py, x2, y2)
    else
      Result := Distance(Px, Py, x1 + (Ratio * Dx), y1 + (Ratio * Dy));
  end;
end;
(* End PointToSegmentDistance *)

function PointToSegmentDistance(const Pnt: TPoint2D; const Seg: TSegment2D): Double;
begin
  Result := PointToSegmentDistance(Pnt.x, Pnt.y, Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y);
end;
(* End PointToSegmentDistance *)

function PointToSegmentDistance(const Px, Py, Pz, x1, y1, z1, x2, y2, z2: Double): Double;
var t: Double;
  Dx: Double;
  Dy: Double;
  Dz: Double;
begin
  if IsEqual(x1, x2) and isEqual(y1, y2) and IsEqual(z1, z2) then
    Result := 0.0
  else
  begin
    Dx := x1 - x2;
    Dy := y1 - y2;
    Dz := z1 - z2;
    t := (((x1 - Px) * Dx) + ((y1 - Py) * Dy) + ((z1 - Pz) * Dz)) / (Dx * Dx + Dy * Dy + Dz * Dz);
    if t < 0.0 then
      Result := Distance(Px, Py, Pz, x1, y1, z1)
    else if t > 1.0 then
      Result := Distance(Px, Py, Pz, x2, y2, z2)
    else
      Result := Distance(Px, Py, Pz, x1 + t * (x2 - x1), y1 + t * (y2 - y1), z1 + t * (z2 - z1));
  end;
end;
(* End PointToSegmentDistance *)

function PointToSegmentDistance(const Pnt: TPoint3D; const Seg: TSegment3D): Double;
begin
  Result := PointToSegmentDistance(Pnt.x, Pnt.y, Pnt.z, Seg[1].x, Seg[1].y, Seg[1].z, Seg[2].x, Seg[2].y, Seg[2].z);
end;
(* End PointToSegmentDistance *)

function PointToRayDistance(const Px, Py, x1, y1, x2, y2: Double): Double;
var Nx: Double;
  Ny: Double;
begin
  PerpendicularPntToRay(x1, y1, x2, y2, Px, Py, Nx, Ny);
  Result := Distance(Px, Py, Nx, Ny);
end;
(* End PointToRayDistance *)

function PointToRayDistance(const Pnt: TPoint2D; const Seg: TSegment2D): Double;
begin
  Result := PointToRayDistance(Pnt.x, Pnt.y, Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y);
end;
(* End PointToRayDistance *)

function SegmentsParallel(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
begin
  Result := IsEqual(((y1 - y2) * (x1 - x2)), ((y3 - y4) * (x3 - x4)));
end;
(* End Of SegmentsParallel *)

function SegmentsParallel(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean;
begin
  Result := SegmentsParallel(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Pnt4.x, Pnt4.y);
end;
(* End Of SegmentsParallel *)

function SegmentsParallel(const Seg1, Seg2: TSegment2D): Boolean;
begin
  Result := SegmentsParallel(Seg1[1].x, Seg1[1].y, Seg1[2].x, Seg1[2].y, Seg2[1].x, Seg2[1].y, Seg2[2].x, Seg2[2].y);
end;
(* End Of SegmentsParallel *)

function SegmentsParallel(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean;
var Dx1, Dx2: Double;
  Dy1, Dy2: Double;
  Dz1, Dz2: Double;
begin
 (*
    Theory:
    If the gradients in the following planes x-y, y-z, z-x are equal then it can be
    said that the segments are parallel in 3D, However as of yet I haven't been able
    to prove this "mathematically".
    Worst case scenario: 6 floating point multiplications and 9 floating point subtractions
 *)
  Result := False;
  Dx1 := x1 - x2;
  Dx2 := x3 - x4;
  Dy1 := y1 - y2;
  Dy2 := y3 - y4;
  Dz1 := z1 - z2;
  Dz2 := z3 - z4;
 //if NotEqual((Dy1 * Dx2) - (Dy2 * Dx1), 0.0) then Exit;
 //if NotEqual((Dz1 * Dy2) - (Dz2 * Dy1), 0.0) then Exit;
 //if NotEqual((Dx1 * Dz2) - (Dx2 * Dz1), 0.0) then Exit;
  if NotEqual((Dy1 * Dx2), (Dy2 * Dx1)) then Exit;
  if NotEqual((Dz1 * Dy2), (Dz2 * Dy1)) then Exit;
  if NotEqual((Dx1 * Dz2), (Dx2 * Dz1)) then Exit;

  Result := True;
end;
(* End Of SegmentsParallel*)

function SegmentsParallel(const Pnt1, Pnt2, Pnt3, Pnt4: TPoint3D): Boolean;
begin
  Result := SegmentsParallel(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z, Pnt4.x, Pnt4.y, Pnt4.z)
end;
(* End Of SegmentsParallel *)

function SegmentsParallel(const Seg1, Seg2: TSegment3D): Boolean;
begin
  Result := SegmentsParallel(Seg1[1], Seg1[2], Seg2[1], Seg2[2]);
end;
(* End Of SegmentsParallel *)

function SegmentsPerpendicular(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
begin
  Result := IsEqual((y2 - y1) * (x3 - x4), (y4 - y3) * (x2 - x1) * -1);
end;
(* End Of SegmentsPerpendicular *)

function SegmentsPerpendicular(const Ln1, Ln2: TLine2D): Boolean;
begin
  Result := SegmentsParallel(Ln1[1].x, Ln1[1].y, Ln1[2].x, Ln1[2].y, Ln2[1].x, Ln2[1].y, Ln2[2].x, Ln2[2].y);
end;
(* End Of SegmentsPerpendicular *)

function SegmentsPerpendicular(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): Boolean;
var Dx1, Dx2: Double;
  Dy1, Dy2: Double;
  Dz1, Dz2: Double;
begin
 (*
    The dot product of the vector forms of the segments will
    be 0 if the segments are perpendicular
 *)
  Dx1 := x1 - x2;
  Dx2 := x3 - x4;
  Dy1 := y1 - y2;
  Dy2 := y3 - y4;
  Dz1 := z1 - z2;
  Dz2 := z3 - z4;
  Result := IsEqual((Dx1 * Dx2) + (Dy1 * Dy2) + (Dz1 * Dz2), 0.0)
end;
(* End Of *)

function SegmentsPerpendicular(const Ln1, Ln2: TLine3D): Boolean;
begin
  Result := SegmentsPerpendicular(Ln1[1].x, Ln1[1].y, Ln1[1].z, Ln1[2].x, Ln1[2].y, Ln1[2].z, Ln2[1].x, Ln2[1].y, Ln2[1].z, Ln2[2].x, Ln2[2].y, Ln2[2].z);
end;
(* End Of SegmentsPerpendicular *)

procedure SetPlane(const xh, xl, yh, yl: Double);
begin
 (* To be implemented at a later date *)
end;
(* End Of *)

procedure SetPlane(const Pnt1, Pnt2: TPoint2D);
begin
 (* To be implemented at a later date *)
end;
(* End Of *)

procedure SetPlane(const Rec: TRectangle);
begin
 (* To be implemented at a later date *)
end;
(* End Of *)

function LineToLineIntersect(x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
begin
  Result := NotEqual((x1 - x2) * (y3 - y4), (y1 - y2) * (x3 - x4));
 //Result := not IsEqual((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4),0.0);
end;
(* End Of LineToLineIntersect *)

function LineToLineIntersect(Ln1, Ln2: TLine2D): Boolean;
begin
  Result := LineToLineIntersect(Ln1[1].x, Ln1[1].y, Ln1[2].x, Ln1[2].y, Ln2[1].x, Ln2[1].y, Ln2[2].x, Ln2[2].y);
end;
(* End Of LineToLineIntersect *)

function RectangleToRectangleIntersect(const x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
begin
 (*
    Assumes that:  x1 < x2, y1 < y2, x3 < x4, y3 < y4
 *)
  Result := ((x1 <= x4) and (x2 <= x3) and (y1 <= y4) and (y2 <= y3));
end;
(* End Of RectangleIntersect *)

function RectangleToRectangleIntersect(const Rec1, Rec2: TRectangle): Boolean;
begin
  Result := RectangleToRectangleIntersect(Rec1[1].x, Rec1[1].y, Rec1[2].x, Rec1[2].y, Rec2[1].x, Rec2[1].y, Rec2[2].x, Rec2[2].y);
end;
(* End Of RectangleIntersect *)

function Intersect(const Cir1, Cir2: TCircle): Boolean;
begin
  Result := (LayDistance(Cir1.x, Cir1.y, Cir2.x, Cir2.y) <= (Cir1.Radius + Cir2.Radius));
end;
(* End Of CircleIntersect *)

function CircleInCircle(const Cir1, Cir2: TCircle): Boolean;
begin
  Result := (PointInCircle(Cir1.x, Cir1.y, Cir2) and (Cir1.Radius < Cir2.Radius));
end;
(* End Of CircleInCircle *)

function IsTangent(Seg: TSegment2D; const Cir: TCircle): Boolean;
var rSqr, drSqr, dSqr: Double;
begin
  Seg := Translate(-Cir.x, -Cir.y, Seg);
  rSqr := Cir.Radius * Cir.Radius;
  drSqr := LayDistance(Seg);
  dSqr := Sqr(Seg[1].x * Seg[2].y - Seg[2].x * Seg[1].y);
  Result := (IsEqual((rSqr * drSqr - dSqr), 0.0));
end;
(* End Of IsTangent *)

function PointOfReflection(const Sx1, Sy1, Sx2, Sy2, P1x, P1y, P2x, P2y: Double; out RPx, RPy: Double): Boolean;
var Ix: Double;
  Iy: Double;
  P1Px: Double;
  P1Py: Double;
  P2Px: Double;
  P2Py: Double;
begin
  Result := False;
  if (not Collinear(Sx1, Sy1, Sx2, Sy2, P1x, P1y)) and
    (not Collinear(Sx1, Sy1, Sx2, Sy2, P2x, P2y)) then
  begin
    PerpendicularPntToRay(Sx1, Sy1, Sx2, Sy2, P1x, P1y, P1Px, P1Py);
    PerpendicularPntToRay(Sx1, Sy1, Sx2, Sy2, P2x, P2y, P2Px, P2Py);
    IntersectionPoint(P1x, P1y, P2Px, P2Py, P2x, P2y, P1Px, P1Py, Ix, Iy);
    PerpendicularPntToRay(Sx1, Sy1, Sx2, Sy2, Ix, Iy, RPx, RPy);
    if IsPointCollinear(Sx1, Sy1, Sx2, Sy2, RPx, RPy) then
      Result := True
  end;
end;
(* End Of PointOfReflection *)

function PointOfReflection(const Seg: TSegment2D; const P1, P2: tPoint2D; out RP: TPoint2D): Boolean;
begin
  Result := PointOfReflection(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, P1.x, P1.y, P2.x, P2.y, RP.x, RP.y);
end;
(* End Of PointOfReflection *)

function Distance(const x1, y1, x2, y2: Double): Double;
var dx: Double;
  dy: Double;
begin
  dx := x2 - x1;
  dy := y2 - y1;
  Result := Sqrt(dx * dx + dy * dy);
end;
(* End Of Distance *)

function Distance(const Pnt1, Pnt2: TPoint2D): Double;
begin
  Result := Distance(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y);
end;

function DistanceEarth(const Pnt1, Pnt2: TPoint2D): Double; overload;
begin
  result := ApproxEllipticalDistance(Pnt1, Pnt2);
end;

function DistanceEarth(const x1, y1, x2, y2: Double): Double; overload;
begin
  result := ApproxEllipticalDistance(y1, x1, y2, x2);
end;

function ApproxEllipticalDistance(const Pnt1, Pnt2: TPoint2D): Double;
begin
  result := ApproxEllipticalDistance(pnt1.y, pnt1.x, pnt2.y, pnt2.x);
end;

function ApproxEllipticalDistance(llat1, llon1, llat2, llon2: Double): Double;
const
  ERAD: double = 6378.135; {Earth's radius in km a equator}
  FLATTENING: double = 1.0 / 298.257223563; {Fractional reduction of radius to poles}
var
  lat1, lat2, lon1, lon2: double;
  f, g, l: double;
  sing, cosl, cosf, sinl, sinf, cosg: double;
  S, C, W, R, H1, H2, D: double;

  function deg2rad(deg: double): double;
  {Degrees to Radians}
  begin
    result := deg * PI / 180.0;
  end;

begin
  try
    if (llat1 = llat2) and (llon1 = llon2) then
    begin
      result := 0.0;
    end else
    begin

      lat1 := DEg2RAd(llat1);
      lon1 := -DEg2RAd(llon1);
      lat2 := DEg2RAd(llat2);
      lon2 := -DEg2RAd(llon2);

      F := (lat1 + lat2) / 2.0;
      G := (lat1 - lat2) / 2.0;
      L := (lon1 - lon2) / 2.0;

      sing := sin(G);
      cosl := cos(L);
      cosf := cos(F);
      sinl := sin(L);
      sinf := sin(F);
      cosg := cos(G);

      S := sing * sing * cosl * cosl + cosf * cosf * sinl * sinl;
      C := cosg * cosg * cosl * cosl + sinf * sinf * sinl * sinl;
      W := arctan2(sqrt(S), sqrt(C));
      R := sqrt((S * C)) / W;
      H1 := (3 * R - 1.0) / (2.0 * C);
      H2 := (3 * R + 1.0) / (2.0 * S);
      D := 2 * W * ERAD;
      result := (D * (1 + FLATTENING * H1 * sinf * sinf * cosg * cosg -
        FLATTENING * H2 * cosf * cosf * sing * sing));
    end;
  except
    result := -1;
  end;
end;

(* End Of Distance *)

function Distance(const x1, y1, z1, x2, y2, z2: Double): Double;
var dx: Double;
  dy: Double;
  dz: Double;
begin
  dx := x2 - x1;
  dy := y2 - y1;
  dz := z2 - z1;
  Result := Sqrt(dx * dx + dy * dy + dz * dz);
end;
(* End Of Distance *)

function Distance(const Pnt1, Pnt2: TPoint3D): Double;
begin
  Result := Distance(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z);
end;
(* End Of Distance *)

function Distance(const Segment: TSegment2D): Double;
begin
  Result := Distance(Segment[1], Segment[2]);
end;
(* End Of Distance *)

function Distance(const Segment: TSegment3D): Double;
begin
  Result := Distance(Segment[1], Segment[2]);
end;
(* End Of Distance *)

function Distance(const Cir1, Cir2: TCircle): Double;
begin
  Result := Distance(Cir1.x, Cir1.y, Cir2.x, Cir2.y);
end;
(* End Of Distance *)

function Distance(const Seg1, Seg2: TSegment3D): Double;
begin
  Result := 0.0;
end;
(* End Of Distance *)

function LayDistance(const x1, y1, x2, y2: Double): Double;
var dx, dy: Double;
begin
  dx := (x2 - x1);
  dy := (y2 - y1);
  Result := dx * dx + dy * dy;
end;
(* End Of LayDistance *)

function LayDistance(const Pnt1, Pnt2: TPoint2D): Double;
begin
  Result := LayDistance(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y);
end;
(* End Of LayDistance *)

function LayDistance(const x1, y1, z1, x2, y2, z2: Double): Double;
var dx, dy, dz: Double;
begin
  dx := x2 - x1;
  dy := y2 - y1;
  dz := z2 - z1;
  Result := dx * dx + dy * dy + dz * dz;
end;
(* End Of LayDistance *)

function LayDistance(const Pnt1, Pnt2: TPoint3D): Double;
begin
  Result := LayDistance(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z);
end;
(* End Of LayDistance *)

function LayDistance(const Seg: TSegment2D): Double;
begin
  Result := LayDistance(Seg[1], Seg[2]);
end;
(* End Of LayDistance *)

function LayDistance(const Seg: TSegment3D): Double;
begin
  Result := LayDistance(Seg[1], Seg[2]);
end;
(* End Of LayDistance *)

function LayDistance(const Cir1, Cir2: TCircle): Double;
begin
  Result := LayDistance(Cir1.x, Cir1.y, Cir2.x, Cir2.y);
end;
(* End Of LayDistance *)

function ManhattanDistance(const x1, y1, x2, y2: Double): Double;
begin
  Result := Abs(x2 - x1) + Abs(y2 - y1);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const Pnt1, Pnt2: TPoint2D): Double;
begin
  Result := ManhattanDistance(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const x1, y1, z1, x2, y2, z2: Double): Double;
begin
  Result := Abs(x2 - x1) + Abs(y2 - y1) + Abs(z2 - z1);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const Pnt1, Pnt2: TPoint3D): Double;
begin
  Result := ManhattanDistance(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const Segment: TSegment2D): Double;
begin
  Result := ManhattanDistance(Segment[1], Segment[2]);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const Segment: TSegment3D): Double;
begin
  Result := ManhattanDistance(Segment[1], Segment[2]);
end;
(* End Of ManhattanDistance *)

function ManhattanDistance(const Cir1, Cir2: TCircle): Double;
begin
  Result := ManhattanDistance(Cir1.x, Cir1.y, Cir2.x, Cir2.y);
end;
(* End Of ManhattanDistance *)

function TriangleType(const x1, y1, x2, y2, x3, y3: Double): TTriangleType;
begin
  if IsEquilateralTriangle(x1, y1, x2, y2, x3, y3) then Result := Equilateral
  else
    if IsIsoscelesTriangle(x1, y1, x2, y2, x3, y3) then Result := Isosceles
    else
      if IsRightTriangle(x1, y1, x2, y2, x3, y3) then Result := Right
      else
        if IsScaleneTriangle(x1, y1, x2, y2, x3, y3) then Result := Scalene
        else
          if IsObtuseTriangle(x1, y1, x2, y2, x3, y3) then Result := Obtuse
          else
            Result := TUnknown;
end;
(* End Of Triangletype *)

function TriangleType(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TTriangleType;
begin
  if IsEquilateralTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) then Result := Equilateral
  else
    if IsIsoscelesTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) then Result := Isosceles
    else
      if IsRightTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) then Result := Right
      else
        if IsScaleneTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) then Result := Scalene
        else
          if IsObtuseTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3) then Result := Obtuse
          else
            Result := TUnknown;
end;
(* End Of Triangletype *)

function TriangleType(const Pnt1, Pnt2, Pnt3: TPoint2D): TTriangleType;
begin
  Result := TriangleType(Pnt1, Pnt2, Pnt3);
end;
(* End Of Triangletype *)

function TriangleType(const Pnt1, Pnt2, Pnt3: TPoint3D): TTriangleType;
begin
  Result := TriangleType(Pnt1, Pnt2, Pnt3);
end;
(* End Of Triangletype *)

function TriangleType(const Tri: TTriangle2D): TTriangleType;
begin
  Result := TriangleType(Tri[1], Tri[2], Tri[3]);
end;
(* End Of Triangletype *)

function TriangleType(const Tri: TTriangle3D): TTriangleType;
begin
  Result := TriangleType(Tri[1], Tri[2], Tri[3]);
end;
(* End Of Triangletype *)

function IsEquilateralTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean;
var d1, d2, d3: Double;
begin
  d1 := LayDistance(x1, y1, x2, y2);
  d2 := LayDistance(x2, y2, x3, y3);
  d3 := LayDistance(x3, y3, x1, y1);
  Result := (IsEqual(d1, d2) and IsEqual(d2, d3));
end;
(* End Of IsEquilateralTriangle *)

function IsEquilateralTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var d1, d2, d3: Double;
begin
  d1 := LayDistance(x1, y1, z1, x2, y2, z2);
  d2 := LayDistance(x2, y2, z2, x3, y3, z3);
  d3 := LayDistance(x3, y3, z3, x1, y1, z1);
  Result := (IsEqual(d1, d2) and IsEqual(d2, d3));
end;
(* End Of IsEquilateralTriangle *)

function IsEquilateralTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean;
begin
  Result := IsEquilateralTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of IsEquilateralTriangle *)

function IsEquilateralTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean;
begin
  Result := IsEquilateralTriangle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of IsEquilateralTriangle *)

function IsEquilateralTriangle(const Tri: TTriangle2D): Boolean;
begin
  Result := IsEquilateralTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsEquilateralTriangle *)

function IsEquilateralTriangle(const Tri: TTriangle3D): Boolean;
begin
  Result := IsEquilateralTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsEquilateralTriangle *)

function IsIsoscelesTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean;
var d1, d2, d3: Double;
begin
  d1 := LayDistance(x1, y1, x2, y2);
  d2 := LayDistance(x2, y2, x3, y3);
  d3 := LayDistance(x3, y3, x1, y1);
  Result := ((IsEqual(d1, d2) or IsEqual(d1, d3)) and NotEqual(d2, d3)) or
    (IsEqual(d2, d3) and NotEqual(d2, d1));
end;
(* End Of IsIsoscelesTriangle *)

function IsIsoscelesTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var d1, d2, d3: Double;
begin
  d1 := LayDistance(x1, y1, z1, x2, y2, z2);
  d2 := LayDistance(x2, y2, z2, x3, y3, z3);
  d3 := LayDistance(x3, y3, z3, x1, y1, z1);
  Result := (
    (IsEqual(d1, d2) or IsEqual(d1, d3)) and NotEqual(d2, d3)) or
    (IsEqual(d2, d3) and NotEqual(d2, d1)
    );
end;
(* End Of IsIsoscelesTriangle *)

function IsIsoscelesTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean;
begin
  Result := IsIsoscelesTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of IsIsoscelesTriangle *)

function IsIsoscelesTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean;
begin
  Result := IsIsoscelesTriangle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of IsIsoscelesTriangle *)

function IsIsoscelesTriangle(const Tri: TTriangle2D): Boolean;
begin
  Result := IsIsoscelesTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsIsoscelesTriangle *)

function IsIsoscelesTriangle(const Tri: TTriangle3D): Boolean;
begin
  Result := IsIsoscelesTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of *)

function IsRightTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean;
var d1: Double;
  d2: Double;
  d3: Double;
begin
  d1 := Distance(x1, y1, x2, y2);
  d2 := Distance(x2, y2, x3, y3);
  d3 := Distance(x3, y3, x1, y1);
  Result := (
    IsEqual(d1 + d2, d3) or
    IsEqual(d1 + d3, d2) or
    IsEqual(d3 + d2, d1)
    );
end;
(* End Of IsRightTriangle *)

function IsRightTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var d1: Double;
  d2: Double;
  d3: Double;
begin
  d1 := Distance(x1, y1, z1, x2, y2, z2);
  d2 := Distance(x2, y2, z2, x3, y3, z3);
  d3 := Distance(x3, y3, z3, x1, y1, z1);
  Result := (
    IsEqual(d1 + d2, d3) or
    IsEqual(d1 + d3, d2) or
    IsEqual(d3 + d2, d1)
    );
end;
(* End Of IsRightTriangle *)

function IsRightTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean;
begin
  Result := IsRightTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of IsRightTriangle *)

function IsRightTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean;
begin
  Result := IsRightTriangle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of IsRightTriangle *)

function IsRightTriangle(const Tri: TTriangle2D): Boolean;
begin
  Result := IsRightTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsRightTriangle *)

function IsRightTriangle(const Tri: TTriangle3D): Boolean;
begin
  Result := IsRightTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsRightTriangle *)

function IsScaleneTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean;
var d1: Double;
  d2: Double;
  d3: Double;
begin
  d1 := LayDistance(x1, y1, x2, y2);
  d2 := LayDistance(x2, y2, x3, y3);
  d3 := LayDistance(x3, y3, x1, y1);
  Result := NotEqual(d1, d2) and NotEqual(d2, d3) and NotEqual(d3, d1);
end;
(* End Of IsScaleneTriangle *)

function IsScaleneTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var d1: Double;
  d2: Double;
  d3: Double;
begin
  d1 := LayDistance(x1, y1, z1, x2, y2, z2);
  d2 := LayDistance(x2, y2, z2, x3, y3, z3);
  d3 := LayDistance(x3, y3, z3, x1, y1, z1);
  Result := NotEqual(d1, d2) and NotEqual(d2, d3) and NotEqual(d3, d1);
end;
(* End Of IsScaleneTriangle *)

function IsScaleneTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean;
begin
  Result := IsScaleneTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of IsScaleneTriangle *)

function IsScaleneTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean;
begin
  Result := IsScaleneTriangle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of IsScaleneTriangle *)

function IsScaleneTriangle(const Tri: TTriangle2D): Boolean;
begin
  Result := IsScaleneTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsScaleneTriangle *)

function IsScaleneTriangle(const Tri: TTriangle3D): Boolean;
begin
  Result := IsScaleneTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsScaleneTriangle *)

function IsObtuseTriangle(const x1, y1, x2, y2, x3, y3: Double): Boolean;
var a1: Double;
  a2: Double;
  a3: Double;
begin
  a1 := VertexAngle(x1, y1, x2, y2, x3, y3);
  a2 := VertexAngle(x3, y3, x1, y1, x2, y2);
  a3 := VertexAngle(x2, y2, x3, y3, x1, y1);
  Result := (a1 > 90.0) or (a2 > 90.0) or (a3 > 90.0);
end;
(* End Of IsObtuseTriangle *)

function IsObtuseTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): Boolean;
var a1: Double;
  a2: Double;
  a3: Double;
begin
  a1 := VertexAngle(x1, y1, z1, x2, y2, z2, x3, y3, z3);
  a2 := VertexAngle(x3, y3, z3, x1, y1, z1, x2, y2, z2);
  a3 := VertexAngle(x2, y2, z2, x3, y3, z3, x1, y1, z1);
  Result := (a1 > 90.0) or (a2 > 90.0) or (a3 > 90.0);
end;
(* End Of IsObtuseTriangle *)

function IsObtuseTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): Boolean;
begin
  Result := IsObtuseTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of IsObtuseTriangle *)

function IsObtuseTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): Boolean;
begin
  Result := IsObtuseTriangle(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of IsObtuseTriangle *)

function IsObtuseTriangle(const Tri: TTriangle2D): Boolean;
begin
  Result := IsObtuseTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsObtuseTriangle *)

function IsObtuseTriangle(const Tri: TTriangle3D): Boolean;
begin
  Result := IsObtuseTriangle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of IsObtuseTriangle *)

function PointInTriangle(const Px, Py, x1, y1, x2, y2, x3, y3: Double): Boolean;
var Or1: Integer;
  Or2: Integer;
  Or3: Integer;
begin
  Or1 := Orientation(x1, y1, x2, y2, Px, Py);
  Or2 := Orientation(x2, y2, x3, y3, Px, Py);
  Or3 := Orientation(x3, y3, x1, y1, Px, Py);
  if Or1 = 0 then
  begin
    if (Or2 = 0) or (Or3 = 0) then
      Result := True
    else
      Result := (Or2 = Or3);
  end
  else if Or2 = 0 then
  begin
    if (Or1 = 0) or (Or3 = 0) then
      Result := True
    else
      Result := (Or1 = Or3);
  end
  else if Or3 = 0 then
  begin
    if (Or2 = 0) or (Or1 = 0) then
      Result := True
    else
      Result := (Or1 = Or2);
  end
  else
    Result := (Or1 = Or2) and (Or2 = Or3);
end;
(* End Of PointInTriangle *)

function PointInTriangle(const Pnt: TPoint2D; const Tri: TTriangle2D): Boolean;
begin
  Result := PointInTriangle(Pnt.x, Pnt.y, Tri[1].x, Tri[1].y,
    Tri[2].x, Tri[2].y,
    Tri[3].x, Tri[3].y);
end;
(* End Of PointInTriangle *)

function PointInCircle(const Px, Py: Double; const Circle: TCircle): Boolean;
begin
  Result := (LayDistance(Px, Py, Circle.x, Circle.y) <= (Circle.Radius * Circle.Radius));
end;
(* End Of PointInCircle *)

function PointInCircle(const Pnt: TPoint2D; const Circle: TCircle): Boolean;
begin
  Result := PointInCircle(Pnt.x, Pnt.y, Circle);
end;
(* End Of PointInCircle *)

function PointOnCircle(const Px, Py: Double; const Circle: TCircle): Boolean;
begin
  Result := IsEqual(LayDistance(Px, Py, Circle.x, Circle.y), (Circle.Radius * Circle.Radius));
end;
(* End Of PointInCircle *)

function PointOnCircle(const Pnt: TPoint2D; const Circle: TCircle): Boolean;
begin
  Result := PointOnCircle(Pnt.x, Pnt.y, Circle);
end;
(* End Of PointInCircle *)

function TriangleInCircle(const Tri: TTriangle2D; const Circle: TCircle): Boolean;
begin
  Result := PointInCircle(Tri[1], Circle) and
    PointInCircle(Tri[2], Circle) and
    PointInCircle(Tri[3], Circle);
end;
(* End Of TriangleInCircle *)

function TriangleOutsideCircle(const Tri: TTriangle2D; const Circle: TCircle): Boolean;
begin
  Result := (not PointInCircle(Tri[1], Circle)) and
    (not PointInCircle(Tri[2], Circle)) and
    (not PointInCircle(Tri[3], Circle));
end;
(* End Of TriangleOutsideCircle *)

function RectangleInCircle(const Rect: TRectangle; const Circle: TCircle): Boolean;
begin
  Result := PointInCircle(Rect[1].x, Rect[1].y, Circle) and
    PointInCircle(Rect[2].x, Rect[2].y, Circle) and
    PointInCircle(Rect[1].x, Rect[2].y, Circle) and
    PointInCircle(Rect[2].x, Rect[1].y, Circle);
end;
(* End Of RectangleInCircle *)

function RectangleOutsideCircle(const Rect: TRectangle; const Circle: TCircle): Boolean;
begin
  Result := (not PointInCircle(Rect[1].x, Rect[1].y, Circle)) and
    (not PointInCircle(Rect[2].x, Rect[2].y, Circle)) and
    (not PointInCircle(Rect[1].x, Rect[2].y, Circle)) and
    (not PointInCircle(Rect[2].x, Rect[1].y, Circle));
end;
(* End Of RectangleInCircle *)

function QuadixInCircle(const Quad: TQuadix2D; const Circle: TCircle): Boolean;
begin
  Result := PointInCircle(Quad[1], Circle) and
    PointInCircle(Quad[2], Circle) and
    PointInCircle(Quad[3], Circle) and
    PointInCircle(Quad[4], Circle);
end;
(* End Of QuadixInCircle *)

function QuadixOutsideCircle(const Quad: TQuadix2D; const Circle: TCircle): Boolean;
begin
  Result := (not PointInCircle(Quad[1], Circle)) and
    (not PointInCircle(Quad[2], Circle)) and
    (not PointInCircle(Quad[3], Circle)) and
    (not PointInCircle(Quad[4], Circle));
end;
(* End Of QuadixInCircle *)

function PointInRectangle(const Px, Py: Double; const x1, y1, x2, y2: Double): Boolean;
begin
  Result := (x1 <= Px) and (x2 >= Px) and (y1 <= Py) and (y2 >= Py);
end;
(* End Of PointInRectangle *)

function PointInRectangle(const Pnt: TPoint2D; const x1, y1, x2, y2: Double): Boolean;
begin
  Result := PointInRectangle(Pnt.x, Pnt.y, x1, y1, x2, y2);
end;
(* End Of PointInRectangle *)

function PointInRectangle(const Px, Py: Double; const Rec: TRectangle): Boolean;
begin
  Result := PointInRectangle(Px, Py, Rec[1].x, Rec[1].y, Rec[2].x, Rec[2].y);
end;
(* End Of PointInRectangle *)

function PointInRectangle(const Pnt: TPoint2D; const Rec: TRectangle): Boolean;
begin
  Result := PointInRectangle(Pnt.x, Pnt.y, Rec[1].x, Rec[1].y, Rec[2].x, Rec[2].y);
end;
(* End Of PointInRectangle *)

function RectangleInRectangle(const Rec1, Rec2 : TRectangle):boolean;
begin
  result :=
   PointInRectangle(Rec1[1],Rec2) or
   PointInRectangle(Rec1[2],Rec2) or
   PointInRectangle(Rec1[1].x, Rec1[2].y, Rec2) or
   PointInRectangle(Rec1[2].x, Rec1[1].y, Rec2);
end;

function TriangleInRectangle(const Tri: TTriangle2D; const Rec: TRectangle): Boolean;
begin
  Result := PointInRectangle(Tri[1], Rec) and
    PointInRectangle(Tri[2], Rec) and
    PointInRectangle(Tri[3], Rec);
end;
(* End Of TriangleInRectangle *)

function TriangleOutsideRectangle(const Tri: TTriangle2D; const Rec: TRectangle): Boolean;
begin
  Result := (not PointInRectangle(Tri[1], Rec)) and
    (not PointInRectangle(Tri[2], Rec)) and
    (not PointInRectangle(Tri[3], Rec));
end;
(* End Of TriangleInRectangle *)

function QuadixInRectangle(const Quad: TQuadix2D; const Rec: TRectangle): Boolean;
begin
  Result := PointInRectangle(Quad[1], Rec) and
    PointInRectangle(Quad[2], Rec) and
    PointInRectangle(Quad[3], Rec) and
    PointInRectangle(Quad[4], Rec);
end;
(* End Of QuadixInRectangle *)

function QuadixOutsideRectangle(const Quad: TQuadix2D; const Rec: TRectangle): Boolean;
begin
  Result := (not PointInRectangle(Quad[1], Rec)) and
    (not PointInRectangle(Quad[2], Rec)) and
    (not PointInRectangle(Quad[3], Rec)) and
    (not PointInRectangle(Quad[4], Rec));
end;
(* End Of QuadixOutsideRectangle *)

function PointInQuadix(const Px, Py, x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
var Or1: Integer;
  Or2: Integer;
  Or3: Integer;
  Or4: Integer;
begin
  Or1 := Orientation(x1, y1, x2, y2, Px, Py);
  Or2 := Orientation(x2, y2, x3, y3, Px, Py);
  Or3 := Orientation(x3, y3, x4, y4, Px, Py);
  Or4 := Orientation(x4, y4, x1, y1, Px, Py);
  if Or1 = 0 then
  begin
    if (Or2 = 0) or (Or4 = 0) then
      Result := True
    else
      Result := (Or2 = Or3) and (Or3 = Or4);
  end
  else if Or2 = 0 then
  begin
    if (Or1 = 0) or (Or3 = 0) then
      Result := True
    else
      Result := (Or1 = Or3) and (Or3 = Or4);
  end
  else if Or3 = 0 then
  begin
    if (Or2 = 0) or (Or4 = 0) then
      Result := True
    else
      Result := (Or1 = Or2) and (Or2 = Or4);
  end
  else if Or4 = 0 then
  begin
    if (Or1 = 0) or (Or3 = 0) then
      Result := True
    else
      Result := (Or1 = Or2) and (Or2 = Or3);
  end
  else
    Result := (Or1 = Or2) and (Or2 = Or3) and (Or3 = Or4);
end;
(* End Of PointInQuadix *)

function PointInQuadix(const Pnt, Pnt1, Pnt2, Pnt3, Pnt4: TPoint2D): Boolean;
begin
  Result := PointInQuadix(Pnt.x, Pnt.y, Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Pnt4.x, Pnt4.y);
end;
(* End Of PointInQuadix *)

function PointInQuadix(const Pnt: TPoint2D; const Quad: TQuadix2D): Boolean;
begin
  Result := PointInQuadix(Pnt, Quad[1], Quad[2], Quad[3], Quad[4]);
end;
(* End Of PointInQuadix *)

function TriangleInQuadix(const Tri: TTriangle2D; const Quad: TQuadix2D): Boolean;
begin
  Result := PointInQuadix(Tri[1], Quad) and
    PointInQuadix(Tri[2], Quad) and
    PointInQuadix(Tri[3], Quad);
end;
(* End Of TriangleInQuadix *)

function TriangleOutsideQuadix(const Tri: TTriangle2D; const Quad: TQuadix2D): Boolean;
begin
  Result := (not PointInQuadix(Tri[1], Quad)) and
    (not PointInQuadix(Tri[2], Quad)) and
    (not PointInQuadix(Tri[3], Quad));
end;
(* End Of TriangleInQuadix *)

function PointInSphere(const x, y, z: Double; const Sphere: TSphere): Boolean;
begin
  Result := (LayDistance(x, y, z, Sphere.z, Sphere.y, Sphere.z) <= (Sphere.Radius * Sphere.Radius));
end;
(* End Of PointInSphere *)

function PointInSphere(const Pnt3D: TPoint3D; const Sphere: TSphere): Boolean;
begin
  Result := PointInSphere(Pnt3D.x, Pnt3D.y, Pnt3D.z, Sphere);
end;
(* End Of PointInSphere *)

function PointOnSphere(const Pnt3D: TPoint3D; const Sphere: TSphere): Boolean;
begin
  Result := IsEqual(LayDistance(Pnt3D.x, Pnt3D.y, Pnt3D.z, Sphere.z, Sphere.y, Sphere.z), (Sphere.Radius * Sphere.Radius));
end;
(* End Of PointOnSphere *)

function PolyhedronInSphere(const Poly: TPolyhedron; const Sphere: TSphere): TInclusion;
var
  i: Integer;
  j: Integer;
  Count: Integer;
  RealCount: Integer;
begin
  RealCount := 0;
  Count := 0;
  for i := 0 to Length(Poly) - 1 do
  begin
    Inc(RealCount, Length(Poly[i]));
    for j := 0 to Length(Poly[i]) - 1 do
      if PointInSphere(Poly[i][j], Sphere) then
        Inc(Count);
  end;
  Result := Partially;
  if Count = 0 then
    Result := Outside
  else if Count = RealCount then
    Result := Fully;
end;
(* End Of PolyhedronInSphere *)

function PointOnPerimeter(const Px, Py, x1, y1, x2, y2: Double): Boolean;
begin
  Result := (((Px = x1) or (Px = x2)) and ((Py = y1) or (Py = y2)));
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Px, Py, x1, y1, x2, y2, x3, y3: Double): Boolean;
begin
  Result := (
    (Orientation(x1, y1, x2, y2, Px, Py) = 0) or
    (Orientation(x2, y2, x3, y3, Px, Py) = 0) or
    (Orientation(x3, y3, x1, y1, Px, Py) = 0)
    );
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Px, Py, x1, y1, x2, y2, x3, y3, x4, y4: Double): Boolean;
begin
  Result := (
    (Orientation(x1, y1, x2, y2, Px, Py) = 0) or
    (Orientation(x2, y2, x3, y3, Px, Py) = 0) or
    (Orientation(x3, y3, x4, y4, Px, Py) = 0) or
    (Orientation(x4, y4, x1, y1, Px, Py) = 0)
    );
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Point: TPoint2D; const Rect: TRectangle): Boolean;
begin
  Result := PointOnPerimeter(Point.x, Point.y, Rect[1].x, Rect[1].y, Rect[2].x, Rect[2].y);
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Point: TPoint2D; const Tri: TTriangle2D): Boolean;
begin
  Result := PointOnPerimeter(Point.x, Point.y, Tri[1].x, Tri[1].y, Tri[2].x, Tri[2].y, Tri[3].x, Tri[3].y);
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Point: TPoint2D; const Quad: TQuadix2D): Boolean;
begin
  Result := PointOnPerimeter(Point.x, Point.y, Quad[1].x, Quad[1].y, Quad[2].x, Quad[2].y, Quad[3].x, Quad[3].y, Quad[4].x, Quad[4].y);
end;
(* End Of PointOnPerimeter *)

function PointOnPerimeter(const Point: TPoint2D; const Cir: TCircle): Boolean;
begin
  Result := (LayDistance(Point.x, Point.y, Cir.x, Cir.y) = (Cir.Radius * Cir.Radius));
end;
(* End Of PointOnPerimeter *)

function GeometricSpan(const Pnt: array of TPoint2D): Double;
var TempDistance: Double;
  i: Integer;
  j: Integer;
begin
  Result := -1;
  for i := 0 to Length(Pnt) - 2 do
  begin
    for j := (i + 1) to Length(Pnt) - 1 do
    begin
      TempDistance := LayDistance(Pnt[i], Pnt[j]);
      if TempDistance > Result then
        Result := TempDistance;
    end;
  end;
  Result := Sqrt(Result);
end;
(* End Of 2D Geometric Span *)

function GeometricSpan(const Pnt: array of TPoint3D): Double;
var TempDistance: Double;
  i: Integer;
  j: Integer;
begin
  Result := -1;
  if Length(Pnt) < 2 then Exit;
  for i := 0 to Length(Pnt) - 2 do
  begin
    for j := (i + 1) to Length(Pnt) - 1 do
    begin
      TempDistance := LayDistance(Pnt[I], Pnt[J]);
      if TempDistance > Result then
        Result := TempDistance;
    end;
  end;
  Result := Sqrt(Result);
end;
(* End Of 3D Geometric Span *)

procedure CreateEquilateralTriangle(x1, y1, x2, y2: Double; out x3, y3: Double);
const Sin60 = 0.86602540378443864676372317075294;
const Cos60 = 0.50000000000000000000000000000000;
begin
 { Translate for x1,y1 to be origin }
  x2 := x2 - x1;
  y2 := y2 - y1;
 { Rotate 60 degrees and translate back }
  x3 := ((x2 * Cos60) - (y2 * Sin60)) + x1;
  y3 := ((y2 * Cos60) + (x2 * Sin60)) + y1;
end;
(* End Of Create Equilateral Triangle *)

procedure CreateEquilateralTriangle(const Pnt1, Pnt2: TPoint2D; out Pnt3: TPoint2D);
begin
  CreateEquilateralTriangle(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y);
end;
(* End Of Create Equilateral Triangle *)

procedure TorricelliPoint(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double);
var
  OETx1: Double;
  OETy1: Double;
  OETx2: Double;
  OETy2: Double;
begin
 {
    Proven by Cavalieri in this book "Exercitationes geometricae" 1647,
    the theory goes, if the triangle has an angle of 120 degrees or more
    the toricelli point lies at the vertex of the large angle. Otherwise
    the point a which the Simpson lines intersect is said to be the optimal
    solution.
    To find an intersection in 2D, all that is needed is 2 lines, hence
    not all three of the Simpson lines are calculated.
 }
 //If VertexAngle(x1,y1,x2,y2,x3,y3) >= 120.0 then
  if GreaterThanOrEqual(VertexAngle(x1, y1, x2, y2, x3, y3), 120.0) then
  begin
    Px := x2;
    Py := y2;
    Exit;
  end
 //else if VertexAngle(x3,y3,x1,y1,x2,y2) >= 120.0 then
  else if GreaterThanOrEqual(VertexAngle(x3, y3, x1, y1, x2, y2), 120.0) then
  begin
    Px := x1;
    Py := y1;
    Exit;
  end
 //else if VertexAngle(x2,y2,x3,y3,x1,y1) >= 120.0 then
  else if GreaterThanOrEqual(VertexAngle(x2, y2, x3, y3, x1, y1), 120.0) then
  begin
    Px := x3;
    Py := y3;
    Exit;
  end
  else
  begin
    if Orientation(x1, y1, x2, y2, x3, y3) = RightHandSide then
    begin
      CreateEquilateralTriangle(x1, y1, x2, y2, OETx1, OETy1);
      CreateEquilateralTriangle(x2, y2, x3, y3, OETx2, OETy2);
    end
    else
    begin
      CreateEquilateralTriangle(x2, y2, x1, y1, OETx1, OETy1);
      CreateEquilateralTriangle(x3, y3, x2, y2, OETx2, OETy2);
    end;
    IntersectionPoint(OETx1, OETy1, x3, y3, OETx2, OETy2, x1, y1, Px, Py);
  end;
end;
(* End Of Create Torricelli Point *)

function TorricelliPoint(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D;
begin
  TorricelliPoint(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Result.x, Result.y);
end;
(* End Of Create Torricelli Point *)

function TorricelliPoint(const Tri: TTriangle2D): TPoint2D;
begin
  Result := TorricelliPoint(Tri[1], Tri[2], Tri[3]);
end;
(* End Of Create Torricelli Point *)

procedure Incenter(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double);
var
  Perim: Double;
  Side12: Double;
  Side23: Double;
  Side31: Double;
begin
  Side12 := Distance(x1, y1, x2, y2);
  Side23 := Distance(x2, y2, x3, y3);
  Side31 := Distance(x3, y3, x1, y1);
 { using Heron's S=UR }
  Perim := 1.0 / (Side12 + Side23 + Side31);
  Px := (Side23 * x1 + Side31 * x2 + Side12 * x3) * Perim;
  Py := (Side23 * y1 + Side31 * y2 + Side12 * y3) * Perim;
end;
(* End Of Incenter *)

function Incenter(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D;
begin
  Incenter(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Result.x, Result.y);
end;
(* End Of Incenter *)

function Incenter(const Tri: TTriangle2D): TPoint2D;
begin
  Incenter(Tri[1].x, Tri[1].y, Tri[2].x, Tri[2].y, Tri[3].x, Tri[3].y, Result.x, Result.y);
end;
(* End Of Incenter *)

procedure Circumcenter(const x1, y1, x2, y2, x3, y3: Double; out Px, Py: Double);
var A: Double;
  C: Double;
  B: Double;
  D: Double;
  E: Double;
  F: Double;
  G: Double;
begin
  A := x2 - x1;
  B := y2 - y1;
  C := x3 - x1;
  D := y3 - y1;
  E := A * (x1 + x2) + B * (y1 + y2);
  F := C * (x1 + x3) + D * (y1 + y3);
  G := 2.0 * (A * (y3 - y2) - B * (x3 - x2));
  if IsEqual(G, 0.0) then Exit;
  Px := (D * E - B * F) / G;
  Py := (A * F - C * E) / G;
end;
(* End Of Circumcenter *)

function Circumcenter(const Pnt1, Pnt2, Pnt3: TPoint2D): TPoint2D;
begin
  Circumcenter(Pnt1.x, Pnt1.y, Pnt2.x, Pnt2.y, Pnt3.x, Pnt3.y, Result.x, Result.y);
end;
(* End Of Circumcenter *)

function Circumcenter(const Tri: TTriangle2D): TPoint2D;
begin
  Circumcenter(Tri[1].x, Tri[1].y, Tri[2].x, Tri[2].y, Tri[3].x, Tri[3].y, Result.x, Result.y);
end;
(* End Of Circumcenter *)

function Circumcircle(const P1, P2, P3: TPoint2D): TCircle;
begin
  Circumcenter(P1.x, P1.y, P2.x, P2.y, P3.x, P3.y, Result.x, Result.y);
  Result.Radius := Distance(P1.x, P1.y, Result.x, Result.y);
end;
(* End Of TriangleCircumCircle *)

function Circumcircle(const Tri: TTriangle2D): TCircle;
begin
  Result := CircumCircle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of TriangleCircumCircle *)

function InscribedCircle(const P1, P2, P3: TPoint2D): TCircle;
var Perimeter: Double;
  Side12: Double;
  Side23: Double;
  Side31: Double;
begin
  Side12 := Distance(P1, P2);
  Side23 := Distance(P2, P3);
  Side31 := Distance(P3, P1);
 { Using Heron's S=UR }
  Perimeter := 1.0 / (Side12 + Side23 + Side31);
  Result.x := (Side23 * P1.x + Side31 * P2.x + Side12 * P3.x) * Perimeter;
  Result.y := (Side23 * P1.y + Side31 * P2.y + Side12 * P3.y) * Perimeter;
  Result.Radius := 0.5 * sqrt((-Side12 + Side23 + Side31) * (Side12 - Side23 + Side31) * (Side12 + Side23 - Side31) * Perimeter);
end;
(* End Of InscribedCircle *)

function InscribedCircle(const Tri: TTriangle2D): TCircle;
begin
  Result := InscribedCircle(Tri[1], Tri[2], Tri[3]);
end;
(* End Of InscribedCircle *)

function ClosestPointOnCircleFromSegment(const Cir: TCircle; Seg: TSegment2D): TPoint2D;
var Nx: Double;
  Ny: Double;
  Ratio: Double;
begin
  PerpendicularPntToSegment(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y, Cir.x, Cir.y, Nx, Ny);
  Ratio := Cir.Radius / Distance(Cir.x, Cir.y, Nx, Ny);
  Result.x := Cir.x + Ratio * (Nx - Cir.x);
  Result.y := Cir.y + Ratio * (Ny - Cir.y);
end;
(* End Of ClosestPointOnCircle *)

function ClosestPointOnSphereFromSegment(const Sphr: TSphere; Seg: TSegment3D): TPoint3D;
var Nx: Double;
  Ny: Double;
  Nz: Double;
  Ratio: Double;
begin
  PerpendicularPntToSegment(Seg[1].x, Seg[1].y, Seg[1].z, Seg[2].x, Seg[2].y, Seg[2].z, Sphr.x, Sphr.y, Sphr.z, Nx, Ny, Nz);
  Ratio := Sphr.Radius / Distance(Sphr.x, Sphr.y, Sphr.z, Nx, Ny, Nz);
  Result.x := Sphr.x + Ratio * (Nx - Sphr.x);
  Result.y := Sphr.y + Ratio * (Ny - Sphr.y);
  Result.z := Sphr.z + Ratio * (Nz - Sphr.z);
end;
(* End Of ClosestPointOnCircle *)

procedure SegmentMidPoint(const x1, y1, x2, y2: Double; out midx, midy: Double);
begin
  midx := (x1 + x2) * 0.5;
  midy := (y1 + y2) * 0.5;
end;
(* End Of SegmentMidPoint *)

function SegmentMidPoint(const P1, P2: TPoint2D): TPoint2D;
begin
  SegmentMidPoint(P1.x, P1.y, P2.x, P2.y, Result.x, Result.y);
end;
(* End Of SegmentMidPoint *)

function SegmentMidPoint(const Seg: TSegment2D): TPoint2D;
begin
  Result := SegmentMidPoint(Seg[1], Seg[2]);
end;
(* End Of SegmentMidPoint *)

procedure SegmentMidPoint(const x1, y1, z1, x2, y2, z2: Double; out midx, midy, midz: Double);
begin
  midx := (x1 + x2) * 0.5;
  midy := (y1 + y2) * 0.5;
  midz := (z1 + z2) * 0.5;
end;
(* End Of SegmentMidPoint *)

function SegmentMidPoint(const P1, P2: TPoint3D): TPoint3D;
begin
  SegmentMidpoint(P1.x, P1.y, P1.z, P2.x, P2.y, P2.z, Result.x, Result.y, Result.z);
end;
(* End Of SegmentMidPoint *)

function SegmentMidPoint(const Seg: TSegment3D): TPoint3D;
begin
  Result := SegmentMidPoint(Seg[1], Seg[2]);
end;
(* End Of SegmentMidPoint *)

function OrthoCenter(const x1, y1, x2, y2, x3, y3: Double): TPoint2D;
begin
 (* To be implemented at a later date *)
end;
(* End Of OrthoCenter *)

function OrthoCenter(const Pnt1, Pnt2, CPnt: TPoint2D): TPoint2D;
begin
 (* To be implemented at a later date *)
end;
(* End Of OrthoCenter *)

function OrthoCenter(const Ln1, Ln2, Ln3: TLine2D): TPoint2D;
begin
 (* To be implemented at a later date *)
end;
(* End Of OrthoCenter *)

function OrthoCenter(const Tri: TTriangle2D): TPoint2D;
begin
 (* To be implemented at a later date *)
end;
(* End Of OrthoCenter *)

function PolygonCentroid(const Polygon: TPolygon2D): TPoint2D;
var
  i: Integer;
  j: Integer;
  asum: Double;
  term: Double;
  xsum: Double;
  ysum: Double;
begin
  Result.x := 0.0;
  Result.y := 0.0;
  if Length(Polygon) < 3 then Exit;
  asum := 0.0;
  xsum := 0.0;
  ysum := 0.0;
  for i := 0 to Length(Polygon) - 1 do
  begin
    term := ((Polygon[j].x * Polygon[i].y) - (Polygon[j].y * Polygon[i].x));
    asum := asum + term;
    xsum := xsum + (Polygon[j].x + Polygon[i].x) * term;
    ysum := ysum + (Polygon[j].y + Polygon[i].y) * term;
    j := i;
  end;
  if notEqual(asum, 0.0) then
  begin
    Result.x := xsum / (3.0 * asum);
    Result.y := ysum / (3.0 * asum);
  end;
end;
(* End Of PolygonCentroid *)

function PolygonCentroid(const Polygon: array of TPoint3D): TPoint3D;
var i: Integer;
begin
  Result.x := 0.0;
  Result.y := 0.0;
  Result.z := 0.0;
  if Length(Polygon) < 3 then Exit;
  for i := 0 to Length(Polygon) - 1 do
  begin
    Result.x := Result.x + Polygon[i].x;
    Result.y := Result.y + Polygon[i].y;
    Result.z := Result.z + Polygon[i].z;
  end;
  Result.x := Result.x / (Length(Polygon) * 1.0);
  Result.y := Result.y / (Length(Polygon) * 1.0);
  Result.z := Result.z / (Length(Polygon) * 1.0);
end;
(* End Of PolygonCentroid *)

function PolygonSegmentIntersect(const Seg: TSegment2D; const Poly: TPolygon2D): Boolean;
var i: Integer;
  j: Integer;
begin
  Result := False;
  if Length(Poly) < 3 then Exit;
  j := Length(Poly) - 1;
  for i := 0 to Length(Poly) - 1 do
  begin
    if Intersect(Seg[1], Seg[2], Poly[i], Poly[j]) then
    begin
      Result := True;
      Break;
    end;
    j := i;
  end;
end;
(* End Of PolygonSegmentIntersect *)

function PolygonInPolygon(const Poly1, Poly2: TPolygon2D): Boolean;
begin
 (* To be implemented at a later date *)
  Result := False;
end;
(* End Of PolygonInPolygon *)

function PolygonIntersect(const Poly1, Poly2: TPolygon2D): Boolean;
var I: Integer;
  J: Integer;
  Poly1Trailer: Integer;
  Poly2Trailer: Integer;
begin
  Result := False;
  if (Length(Poly1) < 3) or (Length(Poly2) < 3) then exit;
  Poly1Trailer := Length(Poly1) - 1;
  for i := 0 to Length(Poly1) - 1 do
  begin
    Poly2Trailer := Length(Poly2) - 1;
    for j := 0 to Length(Poly2) - 1 do
    begin
      if Intersect(Poly1[i], Poly1[Poly1Trailer], Poly2[j], Poly2[Poly2Trailer]) then
      begin
        Result := True;
        Exit;
      end;
      Poly2Trailer := j;
    end;
    Poly1Trailer := i;
  end;
end;
(* End Of PolygonIntersect *)

function PointInConvexPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean;
var i: Integer;
  j: Integer;
  InitialOrientation: Double;
begin
  Result := False;
  if Length(Poly) < 3 then Exit;
  Result := True;
  InitialOrientation := Orientation(Poly[0], Poly[Length(Poly) - 1], Px, Py);
  j := 0;
  if InitialOrientation <> 0 then
    for i := 1 to Length(Poly) - 1 do
    begin
      if InitialOrientation <> Orientation(Poly[i], Poly[j], Px, Py) then
      begin
        Result := False;
        Exit;
      end;
      j := i;
    end;
end;
(* End Of PointInConvexPolygon *)

function PointInConvexPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean;
begin
  Result := PointInConvexPolygon(Pnt.x, Pnt.y, Poly);
end;
(* End Of PointInConvexPolygon *)

function PointInConcavePolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean;
begin
 (* To be implemented at a later date *)
  Result := False;
end;
(* End Of PointInConcavePolygon *)

function PointInConcavePolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean;
begin
  Result := PointInConcavePolygon(Pnt.x, Pnt.y, Poly);
end;
(* End Of PointInConcavePolygon *)

function PointOnPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean;
var i: Integer;
  j: Integer;
begin
  Result := False;
  if Length(Poly) < 3 then Exit;
  Result := True;
  j := Length(Poly) - 1;
  for i := 0 to Length(Poly) - 1 do
  begin
    if IsPointCollinear(Poly[i], Poly[J], Px, Py) then Exit;
    j := i;
  end;
  Result := False;
end;
(* End Of PointOnPolygon *)

function PointOnPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean;
begin
  Result := PointOnPolygon(Pnt.x, Pnt.y, Poly);
end;
(* End Of PointOnPolygon *)

function PointInPolygon(const Px, Py: Double; const Poly: TPolygon2D): Boolean;
var i: Integer;
  j: Integer;
begin
  Result := False;
  if Length(Poly) < 3 then Exit;
  j := Length(Poly) - 1;
  for i := 0 to Length(Poly) - 1 do
  begin
   (*
   //for near exact equivalancy tests use these lines - they will slow the routine down
   //but nonetheless they are slightly more robust
   if (LessThanOrEqual(Poly[i].y,Py) and (Py < Poly[j].y)) or     // an upward crossing
      (LessThanOrEqual(Poly[j].y,Py) and (Py < Poly[i].y)) then   // a downward crossing
   *)
    if ((Poly[i].y <= Py) and (Py < Poly[j].y)) or // an upward crossing
      ((Poly[j].y <= Py) and (Py < Poly[i].y)) then // a downward crossing
    begin
     (* compute the edge-ray intersect @ the x-coordinate *)
      if (Px < ((Poly[j].x - Poly[i].x) * (Py - Poly[i].y) / (Poly[j].y - Poly[i].y) + Poly[i].x)) then
        Result := not Result;
    end;
    j := i;
  end;
end;
(* End PointInPolygon *)

function PointInPolygon(const Pnt: TPoint2D; const Poly: TPolygon2D): Boolean;
begin
  Result := PointInPolygon(Pnt.x, Pnt.y, Poly);
end;
(* End PointInPolygon *)

function ConvexQuadix(const Quad: TQuadix2D): Boolean;
var Orin: Double;
begin
  Result := False;
  Orin := Orientation(Quad[1], Quad[3], Quad[2]);
  if Orin <> Orientation(Quad[2], Quad[4], Quad[3]) then Exit;
  if Orin <> Orientation(Quad[3], Quad[1], Quad[4]) then Exit;
  if Orin <> Orientation(Quad[4], Quad[2], Quad[1]) then Exit;
  Result := True;
end;
(* End Of ConvexQuadix *)

function ComplexPolygon(const Poly: TPolygon2D): Boolean;
begin
  Result := not ConvexPolygon(Poly);
end;
(* End Of ComplexPolygon *)

function SimplePolygon(const Poly: TPolygon2D): Boolean;
begin
  Result := ConvexPolygon(Poly);
end;
(* End Of SimplePolygon *)

function ConvexPolygon(const Poly: TPolygon2D): Boolean;
var i: Integer;
  j: Integer;
  k: Integer;
  InitialOrientation: Integer;
begin
  Result := False;
  if Length(Poly) < 3 then Exit;
  InitialOrientation := Orientation(Poly[Length(Poly) - 2], Poly[Length(Poly) - 1], Poly[0].x, Poly[0].y);
  j := 0;
  k := Length(Poly) - 1;
  for i := 1 to Length(Poly) - 1 do
  begin
    if InitialOrientation <> Orientation(Poly[k], Poly[j], Poly[i].x, Poly[i].y) then Exit;
    k := j;
    j := i;
  end;
  Result := True;
end;
(* End Of ConvexPolygon *)

function ConcavePolygon(const Poly: TPolygon2D): Boolean;
begin
  Result := not ConvexPolygon(Poly);
end;
(* End Of ConcavePolygon *)

function RectangularHull(const Point: array of TPoint2D): TRectangle;
var MaxX: Double;
  MaxY: Double;
  MinX: Double;
  MinY: Double;
  I: Integer;
begin
  if Length(Point) < 2 then Exit;
  MaxX := MinimumX;
  MaxY := MinimumY;
  MinX := MaximumX;
  MinY := MaximumY;
  for i := 0 to Length(Point) - 1 do
  begin
    if Point[i].x < MinX then MinX := Point[i].x;
    if Point[i].x > MaxX then MaxX := Point[i].x;
    if Point[i].y < MinY then MinY := Point[i].y;
    if Point[i].y > MaxY then MaxY := Point[i].y;
  end;
  Result := EquateRectangle(MinX, MinY, MaxX, MaxY);
end;
(* End Of RectangularHull *)

function RectangularHull(const Poly: TPolygon2D): TRectangle;
var Point: array of TPoint2D;
  i: Integer;
begin
  if Length(Poly) < 2 then Exit;
  SetLength(Point, Length(Poly));
  for i := 0 to Length(Poly) - 1 do
    Point[i] := Poly[i];
  Result := RectangularHull(Point);
  Point := nil;
end;
(* End Of RectangularHull *)

function CircularHull(const Poly: TPolygon2D): TCircle;
var I: Integer;
  Cen: TPoint2D;
  LLen: Double;
  LayDist: Double;
begin
  if Length(Poly) < 3 then Exit;
  LLen := -1;
  Cen := PolygonCentroid(Poly);
  for i := 0 to Length(Poly) - 1 do
  begin
    LayDist := LayDistance(Cen, Poly[i]);
    if LayDist > LLen then
      LLen := LayDist;
  end;
  Result.x := Cen.x;
  Result.y := Cen.y;
  Result.Radius := LLen;
end;
(* End Of CircularHull *)

function SphereHull(const Poly: array of TPoint3D): TSphere;
var I: Integer;
  Cen: TPoint3D;
  LLen: Double;
  LayDist: Double;
begin
  if Length(Poly) < 2 then Exit;
  LLen := -1;
  Cen := PolygonCentroid(Poly);
  for i := 0 to Length(Poly) - 1 do
  begin
    LayDist := LayDistance(Cen, Poly[i]);
    if LayDist > LLen then
      LLen := LayDist;
  end;
  Result.x := Cen.x;
  Result.y := Cen.y;
  Result.z := Cen.z;
  Result.Radius := LLen;
end;
(* End Of SphereHull *)

function Clip(Seg: TSegment2D; const Rec: TRectangle): TSegment2D;
const CLIP_LEFT = 1;
const CLIP_RIGHT = 2;
const CLIP_BOTTOM = 4;
const CLIP_TOP = 8;
  function OutCode(x, y: Double): Integer;
  begin
    Result := 0;
    if y < Rec[1].y then
      Result := Result or CLIP_TOP
    else if y > Rec[2].y then
      Result := Result or CLIP_BOTTOM;
    if x < Rec[1].x then
      Result := Result or CLIP_LEFT
    else if x > Rec[2].x then
      Result := Result or CLIP_RIGHT;
  end;
var
  OCPnt: array[1..2] of Integer;
  I: Integer;
  Edge1Clipped: Boolean;
  Edge2Clipped: Boolean;
  Edge3Clipped: Boolean;
  Edge4Clipped: Boolean;
  Dx, Dy: Double;
begin
  Edge1Clipped := False;
  Edge2Clipped := False;
  Edge3Clipped := False;
  Edge4Clipped := False;
  OCPnt[1] := OutCode(Seg[1].x, Seg[1].y);
  OCPnt[2] := OutCode(Seg[2].x, Seg[2].y);
  Dx := (Seg[2].x - Seg[1].x);
  Dy := (Seg[2].y - Seg[1].y);
  Result := Seg;
  if ((OCPnt[1] or OcPnt[2]) = 0) or
    (OCPnt[1] = OCPnt[2]) then Exit
  else
  begin
    {
      Note: Even though the code may seem complex, at most only 2
            divisions ever occur per segment clip.
    }
    for i := 1 to 2 do
    begin
      if ((OCPnt[i] and CLIP_LEFT) <> 0) and (not Edge1Clipped) then
      begin
        Seg[i].y := Seg[1].y + Dy * (Rec[1].x - Seg[1].x) / Dx;
        Seg[i].x := Rec[1].x;
        OCPnt[i] := 0;
        Edge1Clipped := True;
      end
      else if ((OCPnt[i] and CLIP_TOP) <> 0) and (not Edge2Clipped) then
      begin
        Seg[i].x := Seg[1].x + Dx * (Rec[1].y - Seg[1].y) / Dy;
        Seg[i].y := Rec[1].y;
        OCPnt[i] := 0;
        Edge2Clipped := True;
      end
      else if ((OCPnt[i] and CLIP_RIGHT) <> 0) and (not Edge3Clipped) then
      begin
        Seg[i].y := Seg[1].y + Dy * (Rec[2].x - Seg[1].x) / Dx;
        Seg[i].x := Rec[2].x;
        OCPnt[i] := 0;
        Edge3Clipped := True;
      end
      else if ((OCPnt[i] and CLIP_BOTTOM) <> 0) and (not Edge4Clipped) then
      begin
        Seg[i].x := Seg[1].x + Dx * (Rec[2].y - Seg[1].y) / Dy;
        Seg[i].y := Rec[2].y;
        OCPnt[i] := 0;
        Edge4Clipped := True;
      end;
    end;
  end;
  Result := Seg;
end;
(* End Of Clip *)

function Clip(const Seg: TSegment2D; const Tri: TTriangle2D): TSegment2D;
var Pos: Integer;
begin
  Pos := 1;
  if Intersect(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y,
    Tri[1].x, Tri[1].y, Tri[2].x, Tri[2].y, Result[Pos].x, Result[Pos].y) then
    Inc(Pos);
  if Intersect(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y,
    Tri[2].x, Tri[2].y, Tri[3].x, Tri[3].y, Result[Pos].x, Result[Pos].y) then
    Inc(Pos);
  if (Pos < 3) then
    if Intersect(Seg[1].x, Seg[1].y, Seg[2].x, Seg[2].y,
      Tri[3].x, Tri[3].y, Tri[1].x, Tri[1].y, Result[Pos].x, Result[Pos].y) then
      Inc(Pos);
  if Pos = 2 then
  begin
    if PointInTriangle(Seg[1], Tri) then
      Result[Pos] := Seg[1]
    else
      Result[Pos] := Seg[2];
  end;
end;
(* End Of Clip *)

function Clip(const Seg: TSegment2D; const Quad: TQuadix2D): TSegment2D;
var Pos: Integer;
begin
  Pos := 1;
  if Intersect(Seg[1], Seg[2], Quad[1], Quad[2]) then
  begin
    Result[Pos] := IntersectionPoint(Seg[1], Seg[2], Quad[1], Quad[2]);
    Inc(Pos);
  end;
  if Intersect(Seg[1], Seg[2], Quad[2], Quad[3]) then
  begin
    Result[Pos] := IntersectionPoint(Seg[1], Seg[2], Quad[2], Quad[3]);
    Inc(Pos);
  end;
  if Intersect(Seg[1], Seg[2], Quad[3], Quad[4]) and (Pos < 3) then
  begin
    Result[Pos] := IntersectionPoint(Seg[1], Seg[2], Quad[3], Quad[4]);
    Inc(Pos);
  end;
  if Intersect(Seg[1], Seg[2], Quad[4], Quad[1]) and (Pos < 3) then
  begin
    Result[Pos] := IntersectionPoint(Seg[1], Seg[2], Quad[4], Quad[1]);
    Inc(Pos);
  end;
  if Pos = 2 then
  begin
    if PointInQuadix(Seg[1], Quad) then
      Result[Pos] := Seg[1]
    else
      Result[Pos] := Seg[2];
  end;
end;
(* End Of Clip *)

function Area(const Pnt1, Pnt2, Pnt3: TPoint2D): Double;
begin
  Result := 0.5 *
    (
    (Pnt1.x * (Pnt2.y - Pnt3.y)) +
    (Pnt2.x * (Pnt3.y - Pnt1.y)) +
    (Pnt3.x * (Pnt1.y - Pnt2.y))
    );
end;
(* End Of Area 3-2D Points *)

function Area(const Pnt1, Pnt2, Pnt3: TPoint3D): Double;
var Dx1, Dx2: Double;
  Dy1, Dy2: Double;
  Dz1, Dz2: Double;
  Cx, Cy, Cz: Double;
begin
  Dx1 := Pnt2.x - Pnt1.x;
  Dy1 := Pnt2.y - Pnt1.y;
  Dz1 := Pnt2.z - Pnt1.z;
  Dx2 := Pnt3.x - Pnt1.x;
  Dy2 := Pnt3.y - Pnt1.y;
  Dz2 := Pnt3.z - Pnt1.z;
  Cx := Dy1 * Dz2 - Dy2 * Dz1;
  Cy := Dx2 * Dz1 - Dx1 * Dz2;
  Cz := Dx1 * Dy2 - Dx2 * Dy1;
  Result := (sqrt(Cx * Cx + Cy * Cy + Cz * Cz) * 0.5);
end;
(* End Of Area 3-3D Points *)

function Area(const Tri: TTriangle2D): Double;
begin
  Result := 0.5 *
    (
    (Tri[1].x * (Tri[2].y - Tri[3].y)) +
    (Tri[2].x * (Tri[3].y - Tri[1].y)) +
    (Tri[3].x * (Tri[1].y - Tri[2].y))
    );
end;
(* End Of Area 2D Triangle *)

function Area(const Tri: TTriangle3D): Double;
var Dx1, Dx2: Double;
  Dy1, Dy2: Double;
  Dz1, Dz2: Double;
  Cx, Cy, Cz: Double;
begin
  Dx1 := Tri[2].x - Tri[1].x;
  Dy1 := Tri[2].y - Tri[1].y;
  Dz1 := Tri[2].z - Tri[1].z;
  Dx2 := Tri[3].x - Tri[1].x;
  Dy2 := Tri[3].y - Tri[1].y;
  Dz2 := Tri[3].z - Tri[1].z;
  Cx := Dy1 * Dz2 - Dy2 * Dz1;
  Cy := Dx2 * Dz1 - Dx1 * Dz2;
  Cz := Dx1 * Dy2 - Dx2 * Dy1;
  Result := (sqrt(Cx * Cx + Cy * Cy + Cz * Cz) * 0.5);
end;
(* End Of Area 3D Triangle *)

function Area(const Quad: TQuadix2D): Double;
begin
  Result := 0.5 *
    (
    (Quad[1].x * (Quad[2].y - Quad[4].y)) +
    (Quad[2].x * (Quad[3].y - Quad[1].y)) +
    (Quad[3].x * (Quad[4].y - Quad[2].y)) +
    (Quad[4].x * (Quad[1].y - Quad[3].y))
    );
end;
(* End Of Area 2D Qudix *)

function Area(const Quad: TQuadix3D): Double;
begin
  Result := (
    Area(EquateTriangle(Quad[1], Quad[2], Quad[3])) +
    Area(EquateTriangle(Quad[3], Quad[4], Quad[1]))
    );
end;
(* End Of Area 3D Quadix *)

function Area(const Rec: TRectangle): Double;
begin
  Result := (Rec[2].x - Rec[1].x) * (Rec[2].y - Rec[1].y);
end;
(* End Of Area *)

function Area(const Cir: TCircle): Double;
begin
  Result := PI2 * Cir.Radius * Cir.Radius;
end;
(* End Of Area *)

function Area(const Poly: TPolygon2D): Double;
var i: Integer;
  j: Integer;
begin
 (*
 Old implementation uses mod to wrap around - not very efficient...
 Result := 0.0;
 if Length(Poly) < 3 then Exit;
 for i := 0 to Length(Poly) - 1 do
  begin
   Result := Result + (
                       (Poly[i].x * Poly[(i + 1) mod Length(Poly)].y)-
                       (Poly[i].y * Poly[(i + 1) mod Length(Poly)].x)
                      );
  end;
 Result := Result * 0.5;
 *)
  Result := 0.0;
  if Length(Poly) < 3 then Exit;
  j := Length(Poly) - 1;
  for i := 0 to Length(Poly) - 1 do
  begin
    Result := Result + ((Poly[j].x * Poly[i].y) - (Poly[j].y * Poly[i].x));
    j := i;
  end;
  Result := Result * 0.5;
end;
(* End Of Area *)

function Perimeter(const Tri: TTriangle2D): Double;
begin
  Result := Distance(Tri[1], Tri[2]) +
    Distance(Tri[2], Tri[3]) +
    Distance(Tri[3], Tri[1]);
end;
(* End Of Circumference *)

function Perimeter(const Tri: TTriangle3D): Double;
begin
  Result := Distance(Tri[1], Tri[2]) +
    Distance(Tri[2], Tri[3]) +
    Distance(Tri[3], Tri[1]);
end;
(* End Of Circumference *)

function Perimeter(const Quad: TQuadix2D): Double;
begin
  Result := Distance(Quad[1], Quad[2]) +
    Distance(Quad[2], Quad[3]) +
    Distance(Quad[3], Quad[4]);
  Distance(Quad[4], Quad[1]);
end;
(* End Of Circumference *)

function Perimeter(const Quad: TQuadix3D): Double;
begin
  Result := Distance(Quad[1], Quad[2]) +
    Distance(Quad[2], Quad[3]) +
    Distance(Quad[3], Quad[4]);
  Distance(Quad[4], Quad[1]);
end;
(* End Of Circumference *)

function Perimeter(const Rec: TRectangle): Double;
begin
  Result := 2 * ((Rec[2].x - Rec[1].x) + (Rec[2].y - Rec[1].y));
end;
(* End Of Circumference *)

function Perimeter(const Cir: TCircle): Double;
begin
  Result := 2 * Pi * Cir.Radius;
end;
(* End Of Circumference *)

function Perimeter(const Poly: TPolygon2D): Double;
var i: Integer;
  j: Integer;
begin
  Result := 0.0;
  if Length(Poly) < 3 then Exit;
  j := Length(Poly) - 1;
  for i := 0 to Length(Poly) - 1 do
  begin
    Result := Result + Distance(poly[i], Poly[j]);
    j := i;
  end;
end;
(* End Of Circumference *)

procedure Rotate(RotAng: Double; const x, y: Double; out Nx, Ny: Double);
var SinVal: Double;
  CosVal: Double;
begin
  RotAng := RotAng * PIDiv180;
  SinVal := Sin(RotAng);
  CosVal := Cos(RotAng);
  Nx := (x * CosVal) - (y * SinVal);
  Ny := (y * CosVal) + (x * SinVal);
end;
(* End Of Rotate Cartesian Point *)

procedure Rotate(const RotAng: Double; const x, y, ox, oy: Double; out Nx, Ny: Double);
begin
  Rotate(RotAng, x - ox, y - oy, Nx, Ny);
  Nx := Nx + ox;
  Ny := Ny + oy;
end;
(* End Of Rotate Cartesian Point About Origin *)

function Rotate(const RotAng: Double; const Pnt: TPoint2D): TPoint2D;
begin
  Rotate(RotAng, Pnt.x, Pnt.y, Result.x, Result.y);
end;
(* End Of Rotate Point *)

function Rotate(const RotAng: Double; const Pnt, OPnt: TPoint2D): TPoint2D;
begin
  Rotate(RotAng, Pnt.x, Pnt.y, OPnt.x, OPnt.y, Result.x, Result.y);
end;
(* End Of Rotate Point About Origin *)

function Rotate(const RotAng: Double; const Seg: TSegment2D): TSegment2D;
begin
  Result[1] := Rotate(RotAng, Seg[1]);
  Result[2] := Rotate(RotAng, Seg[2]);
end;
(* End Of Rotate Segment*)

function Rotate(const RotAng: Double; const Seg: TSegment2D; const OPnt: TPoint2D): TSegment2D;
begin
  Result[1] := Rotate(RotAng, Seg[1], OPnt);
  Result[2] := Rotate(RotAng, Seg[2], OPnt);
end;
(* End Of Rotate Segment About Origin *)

function Rotate(const RotAng: Double; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1] := Rotate(RotAng, Tri[1]);
  Result[2] := Rotate(RotAng, Tri[2]);
  Result[3] := Rotate(RotAng, Tri[3]);
end;
(* End Of Rotate 2D Triangle*)

function Rotate(const RotAng: Double; const Tri: TTriangle2D; const OPnt: TPoint2D): TTriangle2D;
begin
  Result[1] := Rotate(RotAng, Tri[1], OPnt);
  Result[2] := Rotate(RotAng, Tri[2], OPnt);
  Result[3] := Rotate(RotAng, Tri[3], OPnt);
end;
(* End Of Rotate 2D Triangle About Origin *)

function Rotate(const RotAng: Double; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1] := Rotate(RotAng, Quad[1]);
  Result[2] := Rotate(RotAng, Quad[2]);
  Result[3] := Rotate(RotAng, Quad[3]);
  Result[4] := Rotate(RotAng, Quad[4]);
end;
(* End Of Rotate 2D Quadix*)

function Rotate(const RotAng: Double; const Quad: TQuadix2D; const OPnt: TPoint2D): TQuadix2D;
begin
  Result[1] := Rotate(RotAng, Quad[1], OPnt);
  Result[2] := Rotate(RotAng, Quad[2], OPnt);
  Result[3] := Rotate(RotAng, Quad[3], OPnt);
  Result[4] := Rotate(RotAng, Quad[4], OPnt);
end;
(* End Of Rotate 2D Quadix About Origin *)

function Rotate(const RotAng: Double; Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(RotAng, Poly[i]);
  end;
  Result := Poly;
end;
(* End Of Rotate 2D Polygon *)

function Rotate(const RotAng: Double; Poly: TPolygon2D; const OPnt: TPoint2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(RotAng, Poly[i], OPnt);
  end;
  Result := Poly;
end;
(* End Of Rotate 2D Polygon About Origin *)

procedure Rotate(const Rx, Ry, Rz: Double; const x, y, z: Double; out Nx, Ny, Nz: Double);
var TempX: Double;
  TempY: Double;
  TempZ: Double;
  SinX: Double;
  SinY: Double;
  SinZ: Double;
  CosX: Double;
  CosY: Double;
  CosZ: Double;
  XRadAng: Double;
  YRadAng: Double;
  ZRadAng: Double;
begin
  XRadAng := Rx * PIDiv180;
  YRadAng := Ry * PIDiv180;
  ZRadAng := Rz * PIDiv180;
  SinX := Sin(XRadAng);
  SinY := Sin(YRadAng);
  SinZ := Sin(ZRadAng);
  CosX := Cos(XRadAng);
  CosY := Cos(YRadAng);
  CosZ := Cos(ZRadAng);
  Tempy := y * CosY - z * SinY;
  Tempz := y * SinY + z * CosY;
  Tempx := x * CosX - Tempz * SinX;
  Nz := x * SinX + Tempz * CosX;
  Nx := Tempx * CosZ - TempY * SinZ;
  Ny := Tempx * SinZ + TempY * CosZ;
end;
(* End Of Rotate 3D Point *)

procedure Rotate(const Rx, Ry, Rz: Double; const x, y, z, ox, oy, oz: Double; out Nx, Ny, Nz: Double);
begin
  Rotate(Rx, Ry, Rz, x - ox, y - oy, z - oz, Nx, Ny, Nz);
  Nx := Nx + ox;
  Ny := Ny + oy;
  Nz := Nz + oz;
end;
(* End Of Rotate 3D Point About Origin Point *)

function Rotate(const Rx, Ry, Rz: Double; const Pnt: TPoint3D): TPoint3D;
begin
  Rotate(Rx, Ry, Rz, Pnt.x, Pnt.y, Pnt.z, Result.x, Result.y, Result.z);
end;
(* End Of Rotate 3D Point *)

function Rotate(const Rx, Ry, Rz: Double; const Pnt, OPnt: TPoint3D): TPoint3D;
begin
  Rotate(Rx, Ry, Rz, Pnt.x, Pnt.y, Pnt.z, OPnt.x, OPnt.y, OPnt.z, Result.x, Result.y, Result.z);
end;
(* End Of Rotate 3D Point About Origin Point *)

function Rotate(const Rx, Ry, Rz: Double; const Seg: TSegment3D): TSegment3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Seg[1]);
  Result[2] := Rotate(Rx, Ry, Rz, Seg[2]);
end;
(* End Of Rotate 3D Segment *)

function Rotate(const Rx, Ry, Rz: Double; const Seg: TSegment3D; const OPnt: TPoint3D): TSegment3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Seg[1], OPnt);
  Result[2] := Rotate(Rx, Ry, Rz, Seg[2], OPnt);
end;
(* End Of Rotate 3D Segment About Origin Point *)

function Rotate(const Rx, Ry, Rz: Double; const Tri: TTriangle3D): TTriangle3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Tri[1]);
  Result[2] := Rotate(Rx, Ry, Rz, Tri[2]);
  Result[3] := Rotate(Rx, Ry, Rz, Tri[3]);
end;
(* End Of Rotate 3D Triangle *)

function Rotate(const Rx, Ry, Rz: Double; const Tri: TTriangle3D; const OPnt: TPoint3D): TTriangle3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Tri[1], OPnt);
  Result[2] := Rotate(Rx, Ry, Rz, Tri[2], OPnt);
  Result[3] := Rotate(Rx, Ry, Rz, Tri[3], OPnt);
end;
(* End Of Rotate 3D Triangle About Origin Point *)

function Rotate(const Rx, Ry, Rz: Double; const Quad: TQuadix3D): TQuadix3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Quad[1]);
  Result[2] := Rotate(Rx, Ry, Rz, Quad[2]);
  Result[3] := Rotate(Rx, Ry, Rz, Quad[3]);
  Result[4] := Rotate(Rx, Ry, Rz, Quad[4]);
end;
(* End Of Rotate 3D Quadix *)

function Rotate(const Rx, Ry, Rz: Double; const Quad: TQuadix3D; const OPnt: TPoint3D): TQuadix3D;
begin
  Result[1] := Rotate(Rx, Ry, Rz, Quad[1], OPnt);
  Result[2] := Rotate(Rx, Ry, Rz, Quad[2], OPnt);
  Result[3] := Rotate(Rx, Ry, Rz, Quad[3], OPnt);
  Result[4] := Rotate(Rx, Ry, Rz, Quad[4], OPnt);
end;
(* End Of Rotate 3D Quadix About Origin Point *)

function Rotate(const Rx, Ry, Rz: Double; Poly: TPolygon3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(Rx, Ry, Rz, Poly[i]);
  end;
  Result := Poly;
end;
(* End Of Rotate 3D Polygon *)

function Rotate(const Rx, Ry, Rz: Double; Poly: TPolygon3D; const OPnt: TPoint3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(Rx, Ry, Rz, Poly[i], OPnt);
  end;
  Result := Poly;
end;
(* End Of Rotate 3D Polygon About Origin Point *)

procedure FastRotate(RotAng: Integer; const x, y: Double; out Nx, Ny: Double);
var SinVal: Double;
  CosVal: Double;
begin
  RotAng := RotAng mod 360;
  if RotAng < 0 then RotAng := 360 + RotAng;
  SinVal := SinTable[RotAng];
  CosVal := CosTable[RotAng];
  Nx := x * CosVal - y * SinVal;
  Ny := y * CosVal + x * SinVal;
end;
(* End Of Fast Rotation *)

procedure FastRotate(RotAng: Integer; x, y, ox, oy: Double; out Nx, Ny: Double);
var SinVal: Double;
  CosVal: Double;
begin
  RotAng := RotAng mod 360;
  SinVal := SinTable[RotAng];
  CosVal := CosTable[RotAng];
  x := x - ox;
  y := y - oy;
  Nx := (x * CosVal - y * SinVal) + ox;
  Ny := (y * CosVal + x * SinVal) + oy;
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Pnt: TPoint2D): TPoint2D;
begin
  FastRotate(RotAng, Pnt.x, Pnt.y, Result.x, Result.y);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Pnt, OPnt: TPoint2D): TPoint2D;
begin
  FastRotate(RotAng, Pnt.x, Pnt.y, OPnt.x, OPnt.y, Result.x, Result.y);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Seg: TSegment2D): TSegment2D;
begin
  Result[1] := FastRotate(RotAng, Seg[1]);
  Result[2] := FastRotate(RotAng, Seg[2]);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Seg: TSegment2D; const OPnt: TPoint2D): TSegment2D;
begin
  Result[1] := FastRotate(RotAng, Seg[1], OPnt);
  Result[2] := FastRotate(RotAng, Seg[2], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1] := FastRotate(RotAng, Tri[1]);
  Result[2] := FastRotate(RotAng, Tri[2]);
  Result[3] := FastRotate(RotAng, Tri[3]);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Tri: TTriangle2D; const OPnt: TPoint2D): TTriangle2D;
begin
  Result[1] := FastRotate(RotAng, Tri[1], OPnt);
  Result[2] := FastRotate(RotAng, Tri[2], OPnt);
  Result[3] := FastRotate(RotAng, Tri[3], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1] := FastRotate(RotAng, Quad[1]);
  Result[2] := FastRotate(RotAng, Quad[2]);
  Result[3] := FastRotate(RotAng, Quad[3]);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; const Quad: TQuadix2D; const OPnt: TPoint2D): TQuadix2D;
begin
  Result[1] := FastRotate(RotAng, Quad[1], OPnt);
  Result[2] := FastRotate(RotAng, Quad[2], OPnt);
  Result[3] := FastRotate(RotAng, Quad[3], OPnt);
  Result[4] := FastRotate(RotAng, Quad[4], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(RotAng, Poly[i]);
  end;
  Result := Poly;
end;
(* End Of Fast Rotation *)

function FastRotate(const RotAng: Integer; Poly: TPolygon2D; const OPnt: TPoint2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := Rotate(RotAng, Poly[i], OPnt);
  end;
  Result := Poly;
end;
(* End Of Fast Rotation *)

procedure FastRotate(Rx, Ry, Rz: Integer; const x, y, z: Double; out Nx, Ny, Nz: Double);
var TempX: Double;
  TempY: Double;
  TempZ: Double;
  SinX: Double;
  SinY: Double;
  SinZ: Double;
  CosX: Double;
  CosY: Double;
  CosZ: Double;
begin
  Rx := Rx mod 360;
  Ry := Ry mod 360;
  Rz := Rz mod 360;
  if Rx < 0 then Rx := 360 + Rx;
  if Ry < 0 then Ry := 360 + Ry;
  if Rz < 0 then Rz := 360 + Rz;
  SinX := SinTable[Rx];
  SinY := SinTable[Ry];
  SinZ := SinTable[Rz];
  CosX := CosTable[Rx];
  CosY := CosTable[Ry];
  CosZ := CosTable[Rz];
  Tempy := y * CosY - z * SinY;
  Tempz := y * SinY + z * CosY;
  Tempx := x * CosX - Tempz * SinX;
  Nz := x * SinX + Tempz * CosX;
  Nx := Tempx * CosZ - TempY * SinZ;
  Ny := Tempx * SinZ + TempY * CosZ;
end;
(* End Of Fast Rotation *)

procedure FastRotate(const Rx, Ry, Rz: Integer; const x, y, z, ox, oy, oz: Double; out Nx, Ny, Nz: Double);
begin
  FastRotate(Rx, Ry, Rz, x - ox, y - oy, z - oz, Nx, Ny, Nz);
  Nx := Nx + ox;
  Ny := Ny + oy;
  Nz := Nz + oz;
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Pnt: TPoint3D): TPoint3D;
begin
  FastRotate(Rx, Ry, Rz, Pnt.x, Pnt.y, Pnt.z, Result.x, Result.y, Result.z);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Pnt, OPnt: TPoint3D): TPoint3D;
begin
  FastRotate(Rx, Ry, Rz, Pnt.x, Pnt.y, Pnt.z, OPnt.x, OPnt.y, OPnt.z, Result.x, Result.y, Result.z);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Seg: TSegment3D): TSegment3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Seg[1]);
  Result[2] := FastRotate(Rx, Ry, Rz, Seg[2]);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Seg: TSegment3D; const OPnt: TPoint3D): TSegment3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Seg[1], OPnt);
  Result[2] := FastRotate(Rx, Ry, Rz, Seg[2], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Tri: TTriangle3D): TTriangle3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Tri[1]);
  Result[2] := FastRotate(Rx, Ry, Rz, Tri[2]);
  Result[3] := FastRotate(Rx, Ry, Rz, Tri[3]);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Tri: TTriangle3D; const OPnt: TPoint3D): TTriangle3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Tri[1], OPnt);
  Result[2] := FastRotate(Rx, Ry, Rz, Tri[2], OPnt);
  Result[3] := FastRotate(Rx, Ry, Rz, Tri[3], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Quad: TQuadix3D): TQuadix3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Quad[1]);
  Result[2] := FastRotate(Rx, Ry, Rz, Quad[2]);
  Result[3] := FastRotate(Rx, Ry, Rz, Quad[3]);
  Result[4] := FastRotate(Rx, Ry, Rz, Quad[4]);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; const Quad: TQuadix3D; const OPnt: TPoint3D): TQuadix3D;
begin
  Result[1] := FastRotate(Rx, Ry, Rz, Quad[1], OPnt);
  Result[2] := FastRotate(Rx, Ry, Rz, Quad[2], OPnt);
  Result[3] := FastRotate(Rx, Ry, Rz, Quad[3], OPnt);
  Result[4] := FastRotate(Rx, Ry, Rz, Quad[4], OPnt);
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; Poly: TPolygon3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := FastRotate(Rx, Ry, Rz, Poly[i]);
  end;
end;
(* End Of Fast Rotation *)

function FastRotate(const Rx, Ry, Rz: Integer; Poly: TPolygon3D; const OPnt: TPoint3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := FastRotate(Rx, Ry, Rz, Poly[i], OPnt);
  end;
end;
(* End Of Fast Rotation *)

function Translate(const Dx, Dy: Double; const Pnt: TPoint2D): TPoint2D;
begin
  Result.x := Pnt.x + Dx;
  Result.y := Pnt.y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Ln: TLine2D): TLine2D;
begin
  Result[1].x := Ln[1].x + Dx;
  Result[1].y := Ln[1].y + Dy;
  Result[2].x := Ln[2].x + Dx;
  Result[2].y := Ln[2].y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Seg: TSegment2D): TSegment2D;
begin
  Result[1].x := Seg[1].x + Dx;
  Result[1].y := Seg[1].y + Dy;
  Result[2].x := Seg[2].x + Dx;
  Result[2].y := Seg[2].y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1].x := Tri[1].x + Dx;
  Result[1].y := Tri[1].y + Dy;
  Result[2].x := Tri[2].x + Dx;
  Result[2].y := Tri[2].y + Dy;
  Result[3].x := Tri[3].x + Dx;
  Result[3].y := Tri[3].y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1].x := Quad[1].x + Dx;
  Result[1].y := Quad[1].y + Dy;
  Result[2].x := Quad[2].x + Dx;
  Result[2].y := Quad[2].y + Dy;
  Result[3].x := Quad[3].x + Dx;
  Result[3].y := Quad[3].y + Dy;
  Result[4].x := Quad[4].x + Dx;
  Result[4].y := Quad[4].y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Rec: TRectangle): TRectangle;
begin
  Result[1].x := Rec[1].x + Dx;
  Result[1].y := Rec[1].y + Dy;
  Result[2].x := Rec[2].x + Dx;
  Result[2].y := Rec[2].y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Cir: TCircle): TCircle;
begin
  Result.x := Cir.x + Dx;
  Result.y := Cir.y + Dy;
end;
(* End Of Translate *)

function Translate(const Dx, Dy: Double; const Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Result[i].x := Poly[i].x + Dx;
    Result[i].y := Poly[i].y + Dy;
  end;
end;
(* End Of Translate *)

function Translate(const Pnt: TPoint2D; const Poly: TPolygon2D): TPolygon2D;
begin
  Result := Translate(Pnt.x, Pnt.y, Poly);
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Pnt: TPoint3D): TPoint3D;
begin
  Result.x := Pnt.x + Dx;
  Result.y := Pnt.y + Dy;
  Result.z := Pnt.z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Ln: TLine3D): TLine3D;
begin
  Result[1].x := Ln[1].x + Dx;
  Result[1].y := Ln[1].y + Dy;
  Result[1].z := Ln[1].z + Dz;
  Result[2].x := Ln[2].x + Dx;
  Result[2].y := Ln[2].y + Dy;
  Result[2].z := Ln[2].z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Seg: TSegment3D): TSegment3D;
begin
  Result[1].x := Seg[1].x + Dx;
  Result[1].y := Seg[1].y + Dy;
  Result[1].z := Seg[1].z + Dz;
  Result[2].x := Seg[2].x + Dx;
  Result[2].y := Seg[2].y + Dy;
  Result[2].z := Seg[2].z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Tri: TTriangle3D): TTriangle3D;
begin
  Result[1].x := Tri[1].x + Dx;
  Result[1].y := Tri[1].y + Dy;
  Result[1].z := Tri[1].z + Dz;
  Result[2].x := Tri[2].x + Dx;
  Result[2].y := Tri[2].y + Dy;
  Result[2].z := Tri[2].z + Dz;
  Result[3].x := Tri[3].x + Dx;
  Result[3].y := Tri[3].y + Dy;
  Result[3].z := Tri[3].z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Quad: TQuadix3D): TQuadix3D;
begin
  Result[1].x := Quad[1].x + Dx;
  Result[1].y := Quad[1].y + Dy;
  Result[1].z := Quad[1].z + Dz;
  Result[2].x := Quad[2].x + Dx;
  Result[2].y := Quad[2].y + Dy;
  Result[2].z := Quad[2].z + Dz;
  Result[3].x := Quad[3].x + Dx;
  Result[3].y := Quad[3].y + Dy;
  Result[3].z := Quad[3].z + Dz;
  Result[4].x := Quad[4].x + Dx;
  Result[4].y := Quad[4].y + Dy;
  Result[4].z := Quad[4].z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Sphere: TSphere): TSphere;
begin
  Result.x := Sphere.x + Dx;
  Result.y := Sphere.y + Dy;
  Result.z := Sphere.z + Dz;
end;
(* End Of Translate *)

function Translate(const Dx, Dy, Dz: Double; const Poly: TPolygon3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Result[i].x := Poly[i].x + Dx;
    Result[i].y := Poly[i].y + Dy;
    Result[i].z := Poly[i].z + Dz;
  end;
end;
(* End Of Translate *)

function Translate(const Pnt: TPoint3D; const Poly: TPolygon3D): TPolygon3D;
begin
  Result := Translate(Pnt.x, Pnt.y, Pnt.z, Poly);
end;
(* End Of Translate *)

function Scale(const Dx, Dy: Double; const Pnt: TPoint2D): TPoint2D;
begin
  Result.x := Pnt.x * Dx;
  Result.y := Pnt.y * Dy;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Ln: TLine2D): TLine2D;
begin
  Result[1].x := Ln[1].x * Dx;
  Result[1].y := Ln[1].y * Dy;
  Result[2].x := Ln[2].x * Dx;
  Result[2].y := Ln[2].y * Dy;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Seg: TSegment2D): TSegment2D;
begin
  Result[1].x := Seg[1].x * Dx;
  Result[1].y := Seg[1].y * Dy;
  Result[2].x := Seg[1].x * Dx;
  Result[2].y := Seg[2].y * Dy;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1].x := Tri[1].x * Dx;
  Result[1].y := Tri[1].y * Dy;
  Result[2].x := Tri[2].x * Dx;
  Result[2].y := Tri[2].y * Dy;
  Result[3].x := Tri[3].x * Dx;
  Result[3].y := Tri[3].y * Dy;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1].x := Quad[1].x * Dx;
  Result[1].y := Quad[1].y * Dy;
  Result[2].x := Quad[2].x * Dx;
  Result[2].y := Quad[2].y * Dy;
  Result[3].x := Quad[3].x * Dx;
  Result[3].y := Quad[3].y * Dy;
  Result[4].x := Quad[4].x * Dx;
  Result[4].y := Quad[4].y * Dy;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Rec: TRectangle): TRectangle;
begin
  Result[1].x := Rec[1].x * Dx;
  Result[1].y := Rec[1].y * Dy;
  Result[2].x := Rec[2].x * Dx;
  Result[2].y := Rec[2].y * Dy;
end;
(* End Of Scale*)

function Scale(const Dr: Double; const Cir: TCircle): TCircle;
begin
  Result.x := Cir.x;
  Result.y := Cir.y;
  Result.Radius := Cir.Radius * Dr;
end;
(* End Of Scale *)

function Scale(const Dx, Dy: Double; const Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Result[i].x := Poly[i].x * Dx;
    Result[i].y := Poly[i].y * Dy;
  end;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Pnt: TPoint3D): TPoint3D;
begin
  Result.x := Pnt.x * Dx;
  Result.y := Pnt.y * Dy;
  Result.z := Pnt.z * Dz;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Ln: TLine3D): TLine3D;
begin
  Result[1].x := Ln[1].x * Dx;
  Result[1].y := Ln[1].y * Dy;
  Result[1].z := Ln[1].z * Dz;
  Result[2].x := Ln[2].x * Dx;
  Result[2].y := Ln[2].y * Dy;
  Result[2].z := Ln[2].z * Dz;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Seg: TSegment3D): TSegment3D;
begin
  Result[1].x := Seg[1].x * Dx;
  Result[1].y := Seg[1].y * Dy;
  Result[1].z := Seg[1].z * Dz;
  Result[2].x := Seg[2].x * Dx;
  Result[2].y := Seg[2].y * Dy;
  Result[2].z := Seg[2].z * Dz;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Tri: TTriangle3D): TTriangle3D;
begin
  Result[1].x := Tri[1].x * Dx;
  Result[1].y := Tri[1].y * Dy;
  Result[1].z := Tri[1].z * Dz;
  Result[2].x := Tri[2].x * Dx;
  Result[2].y := Tri[2].y * Dy;
  Result[2].z := Tri[2].z * Dz;
  Result[3].x := Tri[3].x * Dx;
  Result[3].y := Tri[3].y * Dy;
  Result[3].z := Tri[3].z * Dz;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Quad: TQuadix3D): TQuadix3D;
begin
  Result[1].x := Quad[1].x * Dx;
  Result[1].y := Quad[1].y * Dy;
  Result[1].z := Quad[1].z * Dz;
  Result[2].x := Quad[2].x * Dx;
  Result[2].y := Quad[2].y * Dy;
  Result[2].z := Quad[2].z * Dz;
  Result[3].x := Quad[3].x * Dx;
  Result[3].y := Quad[3].y * Dy;
  Result[3].z := Quad[3].z * Dz;
  Result[4].x := Quad[4].x * Dx;
  Result[4].y := Quad[4].y * Dy;
  Result[4].z := Quad[4].z * Dz;
end;
(* End Of Scale *)

function Scale(const Dr: Double; const Sphere: TSphere): TSphere;
begin
  Result.x := Sphere.x;
  Result.y := Sphere.y;
  Result.z := Sphere.z;
  Result.Radius := Sphere.Radius * Dr;
end;
(* End Of Scale *)

function Scale(const Dx, Dy, Dz: Double; const Poly: TPolygon3D): TPolygon3D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Result[i].x := Poly[i].x * Dx;
    Result[i].y := Poly[i].y * Dy;
  end;
end;
(* End Of Scale *)

procedure ShearXAxis(const Shear, x, y: Double; out Nx, Ny: Double);
begin
  Nx := x + Shear * y;
  Ny := y;
end;
(* End Of Shear Cartesian Coordiante Along X-Axis *)

function ShearXAxis(const Shear: Double; const Pnt: TPoint2D): TPoint2D;
begin
  Result := ShearXAxis(Shear, Pnt);
end;
(* End Of Shear 2D Point Along X-Axis *)

function ShearXAxis(const Shear: Double; const Seg: TSegment2D): TSegment2D;
begin
  Result[1] := ShearXAxis(Shear, Seg[1]);
  Result[2] := ShearXAxis(Shear, Seg[2]);
end;
(* End Of Shear 2D Segment Along X-Axis *)

function ShearXAxis(const Shear: Double; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1] := ShearXAxis(Shear, Tri[1]);
  Result[2] := ShearXAxis(Shear, Tri[2]);
  Result[3] := ShearXAxis(Shear, Tri[2]);
end;
(* End Of Shear 2D Triangle Along X-Axis *)

function ShearXAxis(const Shear: Double; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1] := ShearXAxis(Shear, Quad[1]);
  Result[2] := ShearXAxis(Shear, Quad[2]);
  Result[3] := ShearXAxis(Shear, Quad[2]);
  Result[3] := ShearXAxis(Shear, Quad[2]);
end;
(* End Of Shear 2D Quadix Along X-Axis *)

function ShearXAxis(const Shear: Double; Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := ShearXAxis(Shear, Poly[i]);
  end;
  Result := Poly;
end;
(* End Of Shear 2D Polygon Along X-Axis *)

procedure ShearYAxis(const Shear, x, y: Double; out Nx, Ny: Double);
begin
  Nx := x;
  Ny := x * Shear + y;
end;
(* End Of Shear Cartesian Coordiante Along Y-Axis *)

function ShearYAxis(const Shear: Double; const Pnt: TPoint2D): TPoint2D;
begin
  Result := ShearYAxis(Shear, Pnt);
end;
(* End Of Shear 2D Point Along Y-Axis *)

function ShearYAxis(const Shear: Double; const Seg: TSegment2D): TSegment2D;
begin
  Result[1] := ShearYAxis(Shear, Seg[1]);
  Result[2] := ShearYAxis(Shear, Seg[2]);
end;
(* End Of Shear 2D Segment Along Y-Axis *)

function ShearYAxis(const Shear: Double; const Tri: TTriangle2D): TTriangle2D;
begin
  Result[1] := ShearYAxis(Shear, Tri[1]);
  Result[2] := ShearYAxis(Shear, Tri[2]);
  Result[3] := ShearYAxis(Shear, Tri[2]);
end;
(* End Of Shear 2D Triangle Along Y-Axis *)

function ShearYAxis(const Shear: Double; const Quad: TQuadix2D): TQuadix2D;
begin
  Result[1] := ShearYAxis(Shear, Quad[1]);
  Result[2] := ShearYAxis(Shear, Quad[2]);
  Result[3] := ShearYAxis(Shear, Quad[2]);
  Result[3] := ShearYAxis(Shear, Quad[2]);
end;
(* End Of Shear 2D Quadix Along X-Axis *)

function ShearYAxis(const Shear: Double; Poly: TPolygon2D): TPolygon2D;
var i: Integer;
begin
  for i := 0 to Length(Poly) - 1 do
  begin
    Poly[i] := ShearYAxis(Shear, Poly[i]);
  end;
  Result := Poly;
end;
(* End Of Shear 2D Polygon Along Y-Axis *)

function EquatePoint(const x, y: Double): TPoint2D;
begin
  Result.x := x;
  Result.y := y;
end;
(* End Of EquatePoint *)

function EquatePoint(const x, y, z: Double): TPoint3D;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;
(* End Of EquatePoint *)

procedure EquatePoint(const x, y: Double; out Point: TPoint2D);
begin
  Point.x := x;
  Point.y := y;
end;
(* End Of EquatePoint *)

procedure EquatePoint(const x, y, z: Double; out Point: TPoint3D);
begin
  Point.x := x;
  Point.y := y;
  Point.z := z;
end;
(* End Of EquatePoint *)

function EquateSegment(const x1, y1, x2, y2: Double): TSegment2D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[1].y := y1;
  Result[2].y := y2;
end;
(* End Of EquateSegment *)

function EquateSegment(const x1, y1, z1, x2, y2, z2: Double): TSegment3D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[1].y := y1;
  Result[2].y := y2;
  Result[1].z := z1;
  Result[2].z := z2;
end;
(* End Of EquateSegment *)

procedure EquateSegment(const x1, y1, x2, y2: Double; out Seg: TSegment2D);
begin
  Seg[1].x := x1;
  Seg[2].x := x2;
  Seg[1].y := y1;
  Seg[2].y := y2;
end;
(* End Of EquateSegment *)

procedure EquateSegment(const x1, y1, z1, x2, y2, z2: Double; out Seg: TSegment3D);
begin
  Seg[1].x := x1;
  Seg[2].x := x2;
  Seg[1].y := y1;
  Seg[2].y := y2;
  Seg[1].z := z1;
  Seg[2].z := z2;
end;
(* End Of EquateSegment *)

function EquateQuadix(const x1, y1, x2, y2, x3, y3, x4, y4: Double): TQuadix2D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[3].x := x3;
  Result[4].x := x4;
  Result[1].y := y1;
  Result[2].y := y2;
  Result[3].y := y3;
  Result[4].y := y4;
end;
(* End Of EquateQuadix *)

function EquateQuadix(const x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4: Double): TQuadix3D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[3].x := x3;
  Result[4].x := x4;
  Result[1].y := y1;
  Result[2].y := y2;
  Result[3].y := y3;
  Result[4].y := y4;
  Result[1].z := z1;
  Result[2].z := z2;
  Result[3].z := z3;
  Result[4].z := z4;
end;
(* End Of EquateQuadix *)

function EquateRectangle(const x1, y1, x2, y2: Double): TRectangle;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[1].y := y1;
  Result[2].y := y2;
end;
(* End Of EquateRectangle *)

function EquateTriangle(const x1, y1, x2, y2, x3, y3: Double): TTriangle2D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[3].x := x3;
  Result[1].y := y1;
  Result[2].y := y2;
  Result[3].y := y3;
end;
(* End Of EquateTriangle *)

function EquateTriangle(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TTriangle3D;
begin
  Result[1].x := x1;
  Result[2].x := x2;
  Result[3].x := x3;
  Result[1].y := y1;
  Result[2].y := y2;
  Result[3].y := y3;
  Result[1].z := z1;
  Result[2].z := z2;
  Result[3].z := z3;
end;
(* End Of EquateTriangle *)

function EquateTriangle(const Pnt1, Pnt2, Pnt3: TPoint2D): TTriangle2D;
begin
  Result[1] := Pnt1;
  Result[2] := Pnt2;
  Result[3] := Pnt3;
end;
(* End Of EquateTriangle *)

function EquateTriangle(const Pnt1, Pnt2, Pnt3: TPoint3D): TTriangle3D;
begin
  Result[1] := Pnt1;
  Result[2] := Pnt2;
  Result[3] := Pnt3;
end;
(* End Of EquateTriangle *)

function EquateCircle(const x, y, r: Double): TCircle;
begin
  Result.x := x;
  Result.y := y;
  Result.Radius := r;
end;
(* End Of EquateCircle *)

function EquateSphere(const x, y, z, r: Double): TSphere;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
  Result.Radius := r;
end;
(* End Of EquateSphere *)

function EquatePlane(const x1, y1, z1, x2, y2, z2, x3, y3, z3: Double): TPlane2D;
begin
  Result.a := y1 * (z2 - z3) + y2 * (z3 - z1) + y3 * (z1 - z2);
  Result.b := z1 * (x2 - x3) + z2 * (x3 - x1) + z3 * (x1 - x2);
  Result.c := x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2);
  Result.d := -(x1 * (y2 * z3 - y3 * z2) + x2 * (y3 * z1 - y1 * z3) + x3 * (y1 * z2 - y2 * z1));
end;
(* End Of EquatePlane *)

function EquatePlane(const Pnt1, Pnt2, Pnt3: TPoint3D): TPlane2D;
begin
  Result := EquatePlane(Pnt1.x, Pnt1.y, Pnt1.z, Pnt2.x, Pnt2.y, Pnt2.z, Pnt3.x, Pnt3.y, Pnt3.z);
end;
(* End Of EquatePlane *)

procedure GenerateRandomPoints(const Bx1, By1, Bx2, By2: Double; out Point: array of TPoint2D);
var i: LongInt;
  Dx, Dy: Integer;
begin
  Randomize;
  Dx := Round(Abs(Bx2 - Bx1)) {- 1};
  Dy := Round(Abs(By2 - By1)) {- 1};
  for i := 0 to Length(Point) - 1 do
  begin
    Point[i].x := Bx1 + Random(Dx) {+ (1 / (Random(1000) + 1))};
    Point[i].y := By1 + Random(Dy) {+ (1 / (Random(1000) + 1))};
  end;
end;
(* End Generate Random Points *)

function Add(const Vec1, Vec2: TVector2D): TVector2D;
begin
  Result.x := Vec1.x + Vec2.x;
  Result.y := Vec1.y + Vec2.y;
end;
(* End Of Add *)

function Add(const Vec1, Vec2: TVector3D): TVector3D;
begin
  Result.x := Vec1.x + Vec2.x;
  Result.y := Vec1.y + Vec2.y;
  Result.z := Vec1.z + Vec2.z;
end;
(* End Of Add *)

function Add(const Vec: TVector2DArray): TVector2D;
var i: Integer;
begin
  Result.x := 0.0;
  Result.y := 0.0;
  for i := 0 to Length(Vec) - 1 do
  begin
    Result.x := Result.x + Vec[i].x;
    Result.y := Result.y + Vec[i].y;
  end;
end;
(* End Of Add *)

function Add(const Vec: TVector3DArray): TVector3D;
var i: Integer;
begin
  Result.x := 0.0;
  Result.y := 0.0;
  Result.z := 0.0;
  for i := 0 to Length(Vec) - 1 do
  begin
    Result.x := Result.x + Vec[i].x;
    Result.y := Result.y + Vec[i].y;
    Result.z := Result.z + Vec[i].z;
  end;
end;
(* End Of Add *)

function Sub(const Vec1, Vec2: TVector2D): TVector2D;
begin
  Result.x := Vec1.x - Vec2.x;
  Result.y := Vec1.y - Vec2.y;
end;
(* End Of Sub *)

function Sub(const Vec1, Vec2: TVector3D): TVector3D;
begin
  Result.x := Vec1.x - Vec2.x;
  Result.y := Vec1.y - Vec2.y;
  Result.z := Vec1.z - Vec2.z;
end;
(* End Of Sub *)

function Mul(const Vec1, Vec2: TVector2D): TVector3D;
begin
end;
(* End Of *)

function Mul(const Vec1, Vec2: TVector3D): TVector3D;
begin
  Result.x := Vec1.y * Vec2.z - Vec1.z * Vec2.y;
  Result.y := Vec1.z * Vec2.x - Vec1.x * Vec2.z;
  Result.z := Vec1.x * Vec2.y - Vec1.y * Vec2.x;
end;
(* End Of Multiply (cross-product) *)

function UnitVector(const Vec: TVector2D): TVector2D;
var Mag: Double;
begin
  Mag := Magnitude(Vec);
  if Mag > 0.0 then
  begin
    Result.x := Vec.x / Mag;
    Result.y := Vec.y / Mag;
  end
  else
  begin
    Result.x := 0.0;
    Result.y := 0.0;
  end;
end;
(* End Of UnitVector *)

function UnitVector(const Vec: TVector3D): TVector3D;
var Mag: Double;
begin
  Mag := Magnitude(Vec);
  if Mag > 0.0 then
  begin
    Result.x := Vec.x / Mag;
    Result.y := Vec.y / Mag;
    Result.z := Vec.z / Mag;
  end
  else
  begin
    Result.x := 0.0;
    Result.y := 0.0;
    Result.z := 0.0;
  end;
end;
(* End Of UnitVector *)

function Magnitude(const Vec: TVector2D): Double;
begin
  Result := Sqrt((Vec.x * Vec.x) + (Vec.y * Vec.y));
end;
(* End Of Magnitude *)

function Magnitude(const Vec: TVector3D): Double;
begin
  Result := Sqrt((Vec.x * Vec.x) + (Vec.y * Vec.y) + (Vec.z * Vec.z));
end;
(* End Of Magnitude *)

function DotProduct(const Vec1, Vec2: TVector2D): Double;
begin
  Result := Vec1.x * Vec2.x + Vec1.y * Vec2.y;
end;
(* End Of DotProduct *)

function DotProduct(const Vec1, Vec2: TVector3D): Double;
begin
  Result := Vec1.x * Vec2.x + Vec1.y * Vec2.y + Vec1.z * Vec2.z;
end;
(* End Of DotProduct *)

function Scale(const Vec: TVector2D; const Factor: Double): TVector2D;
begin
  Result.x := Vec.x * Factor;
  Result.y := Vec.y * Factor;
end;
(* End Of Scale *)

function Scale(const Vec: TVector3D; const Factor: Double): TVector3D;
begin
  Result.x := Vec.x * Factor;
  Result.y := Vec.y * Factor;
  Result.z := Vec.z * Factor;
end;
(* End Of Scale *)

function Scale(Vec: TVector2DArray; const Factor: Double): TVector2DArray;
var i: Integer;
begin
  for i := 0 to Length(Vec) - 1 do
  begin
    Vec[i].x := Vec[i].x * Factor;
    Vec[i].y := Vec[i].y * Factor;
  end;
  Result := Vec;
end;
(* End Of Scale *)

function Scale(Vec: TVector3DArray; const Factor: Double): TVector3DArray;
var i: Integer;
begin
  for i := 0 to Length(Vec) - 1 do
  begin
    Vec[i].x := Vec[i].x * Factor;
    Vec[i].y := Vec[i].y * Factor;
    Vec[i].z := Vec[i].z * Factor;
  end;
  Result := Vec;
end;
(* End Of Scale *)

function Negate(const Vec: TVector2D): TVector2D;
begin
  Result.x := -Vec.x;
  Result.y := -Vec.y;
end;
(* End Of Negate *)

function Negate(const Vec: TVector3D): TVector3D;
begin
  Result.x := -Vec.x;
  Result.y := -Vec.y;
  Result.z := -Vec.z;
end;
(* End Of Negate *)

function Negate(Vec: TVector2DArray): TVector2DArray;
var i: Integer;
begin
  for i := 0 to Length(Vec) - 1 do
  begin
    Vec[i].x := -Vec[i].x;
    Vec[i].y := -Vec[i].y;
  end;
  Result := Vec;
end;
(* End Of Negate *)

function Negate(Vec: TVector3DArray): TVector3DArray;
var i: Integer;
begin
  for i := 0 to Length(Vec) - 1 do
  begin
    Vec[i].x := -Vec[i].x;
    Vec[i].y := -Vec[i].y;
    Vec[i].z := -Vec[i].z;
  end;
  Result := Vec;
end;
(* End Of Negate *)

procedure InitialiseTrigonometryTables;
var i: Integer;
begin
 (*
    Note: Trigonometry look-up tables are used to speed-up
          sine,cosine and tangent calculations.
 *)
  SetLength(CosTable, 360);
  SetLength(SinTable, 360);
  SetLength(TanTable, 360);
  for i := 0 to 359 do
  begin
    CosTable[i] := Cos((1.0 * i) * PIDiv180);
    SinTable[i] := Sin((1.0 * i) * PIDiv180);
    TanTable[i] := Tan((1.0 * i) * PIDiv180);
  end;
end;
(* End Of Initialise Trigonometry Tables *)

function IsEqual(const Val1, Val2, Epsilon: Double): Boolean;
var Diff: Double;
begin
  Diff := Val1 - Val2;
  Assert(((-Epsilon <= Diff) and (Diff <= Epsilon)) = (Abs(Diff) <= Epsilon), 'Error - Illogical error in equality check. (IsEqual)');
  Result := ((-Epsilon <= Diff) and (Diff <= Epsilon));
end;
(* End Of Is Equal *)

function IsEqual(const Pnt1, Pnt2: TPoint2D; const Epsilon: Double): Boolean;
begin
  Result := (IsEqual(Pnt1.x, Pnt2.x, Epsilon) and IsEqual(Pnt1.y, Pnt2.y, Epsilon));
end;
(* End Of Is Equal *)

function IsEqual(const Pnt1, Pnt2: TPoint3D; const Epsilon: Double): Boolean;
begin
  Result := (IsEqual(Pnt1.x, Pnt2.x, Epsilon) and IsEqual(Pnt1.y, Pnt2.y, Epsilon) and IsEqual(Pnt1.z, Pnt2.z, Epsilon));
end;
(* End Of Is Equal *)

function IsEqual(const Val1, Val2: Double): Boolean;
begin
  Result := IsEqual(Val1, Val2, Epsilon);
end;
(* End Of Is Equal *)

function IsEqual(const Pnt1, Pnt2: TPoint2D): Boolean;
begin
  Result := (IsEqual(Pnt1.x, Pnt2.x, Epsilon) and IsEqual(Pnt1.y, Pnt2.y, Epsilon));
end;
(* End Of Is Equal *)

function IsEqual(const Pnt1, Pnt2: TPoint3D): Boolean;
begin
  Result := (IsEqual(Pnt1.x, Pnt2.x, Epsilon) and IsEqual(Pnt1.y, Pnt2.y, Epsilon) and IsEqual(Pnt1.z, Pnt2.z, Epsilon));
end;
(* End Of Is Equal *)

function NotEqual(const Val1, Val2, Epsilon: Double): Boolean;
var Diff: Double;
begin
  Diff := Val1 - Val2;
  Assert(((-Epsilon > Diff) or (Diff > Epsilon)) = (Abs(Val1 - Val2) > Epsilon), 'Error - Illogical error in equality check. (NotEqual)');
  Result := ((-Epsilon > Diff) or (Diff > Epsilon));
end;
(* End Of not Equal *)

function NotEqual(const Pnt1, Pnt2: TPoint2D; const Epsilon: Double): Boolean;
begin
  Result := (NotEqual(Pnt1.x, Pnt2.x, Epsilon) or NotEqual(Pnt1.y, Pnt2.y, Epsilon));
end;
(* End Of not Equal *)

function NotEqual(const Pnt1, Pnt2: TPoint3D; const Epsilon: Double): Boolean;
begin
  Result := (NotEqual(Pnt1.x, Pnt2.x, Epsilon) or NotEqual(Pnt1.y, Pnt2.y, Epsilon) or NotEqual(Pnt1.z, Pnt2.z, Epsilon));
end;
(* End Of not Equal *)

function NotEqual(const Val1, Val2: Double): Boolean;
begin
  Result := NotEqual(Val1, Val2, Epsilon);
end;
(* End Of not Equal *)

function NotEqual(const Pnt1, Pnt2: TPoint2D): Boolean;
begin
  Result := (NotEqual(Pnt1.x, Pnt2.x, Epsilon) or NotEqual(Pnt1.y, Pnt2.y, Epsilon));
end;
(* End Of not Equal *)

function NotEqual(const Pnt1, Pnt2: TPoint3D): Boolean;
begin
  Result := (NotEqual(Pnt1.x, Pnt2.x, Epsilon) or NotEqual(Pnt1.y, Pnt2.y, Epsilon) or NotEqual(Pnt1.z, Pnt2.z, Epsilon));
end;
(* End Of not Equal *)

function LessThanOrEqual(const Val1, Val2, Epsilon: Double): Boolean;
begin
  Result := (Val1 < Val2) or IsEqual(Val1, Val2, Epsilon);
end;
(* End Of Less Than Or Equal *)

function LessThanOrEqual(const Val1, Val2: Double): Boolean;
begin
  Result := (Val1 < Val2) or IsEqual(Val1, Val2);
end;
(* End Of Less Than Or Equal *)

function GreaterThanOrEqual(const Val1, Val2, Epsilon: Double): Boolean;
begin
  Result := (Val1 > Val2) or IsEqual(Val1, Val2, Epsilon);
end;
(* End Of Less Than Or Equal *)

function GreaterThanOrEqual(const Val1, Val2: Double): Boolean;
begin
  Result := (Val1 > Val2) or IsEqual(Val1, Val2);
end;
(* End Of Less Than Or Equal *)

function IsEqualZero(const Val, Epsilon: Double): Boolean;
begin
  Result := (Val <= Epsilon);
end;
(* End Of IsEqualZero *)

function IsEqualZero(const Val: Double): Boolean;
begin
  Result := IsEqualZero(Val, Epsilon);
end;
(* End Of IsEqualZero *)

function CalculateSystemEpsilon: Double;
var
  Epsilon: Double;
  Check: Double;
  LastCheck: Double;
begin
  Epsilon := 1.0;
  Check := 1.0;
  repeat
    LastCheck := Check;
    Epsilon := Epsilon * 0.5;
    Check := 1.0 + Epsilon;
  until (Check = 1.0) or (Check = LastCheck);
  Result := Epsilon;
end;
(* End Of CalculateSystemEpsilon *)

function ZeroEquivalency: Boolean;
begin
  Result := IsEqual(CalculateSystemEpsilon, 0.0);
end;
(* End Of ZeroEquivalency *)

// AF

function center(const r: TRectangle): TPoint2D;
begin
  result.x := r[1].x + (r[2].x - r[1].x) / 2;
  result.y := r[2].y + (r[1].y - r[2].y) / 2;
end;

function km(const d: double): double;
begin
  result := EinGrad * d;
end;

// AF

initialization
  SystemEpsilon := CalculateSystemEpsilon;
  MaximumX := 1.0E300;
  MinimumX := -1.0E300;
  MaximumY := 1.0E300;
  MinimumY := -1.0E300;
  MaximumZ := 1.0E300;
  MinimumZ := -1.0E300;
  InitialiseTrigonometryTables;
  (* System precision sanity checks *)
  Assert(LessThanOrEqual(SystemEpsilon, Epsilon), #13 + 'WARNING - System epsilon is greater than static epsilon' + #13 +
    'Accuracy and robustness of calculations that use epsilon for equivalency operations may vary - hence cannot be guaranteed.' + #13);
  Assert(ZeroEquivalency, #13 + 'WARNING - Pseudo zero equivalency test failed!');

finalization
  CosTable := nil;
  SinTable := nil;
  TanTable := nil;
end.

