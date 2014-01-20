<?php

if (!class_exists("SortOrder")) {
/**
 * SortOrder
 */
class SortOrder {
}}

if (!class_exists("ClassificationDescription")) {
/**
 * ClassificationDescription
 */
class ClassificationDescription {
}}

if (!class_exists("ResultField")) {
/**
 * ResultField
 */
class ResultField {
}}

if (!class_exists("SearchParameter")) {
/**
 * SearchParameter
 */
class SearchParameter {
}}

if (!class_exists("DetailLevelDescription")) {
/**
 * DetailLevelDescription
 */
class DetailLevelDescription {
}}

if (!class_exists("ErrorCode")) {
/**
 * ErrorCode
 */
class ErrorCode {
}}

if (!class_exists("ReverseSearchParameter")) {
/**
 * ReverseSearchParameter
 */
class ReverseSearchParameter {
}}

if (!class_exists("PoiSearchParameter")) {
/**
 * PoiSearchParameter
 */
class PoiSearchParameter {
}}

if (!class_exists("GeometryEncoding")) {
/**
 * GeometryEncoding
 */
class GeometryEncoding {
}}

if (!class_exists("CoordFormat")) {
/**
 * CoordFormat
 */
class CoordFormat {
}}

if (!class_exists("TransientVO")) {
/**
 * TransientVO
 */
class TransientVO {
}}

if (!class_exists("OID")) {
/**
 * OID
 */
class OID {
}}

if (!class_exists("VO")) {
/**
 * VO
 */
class VO {
}}

if (!class_exists("StackElement")) {
/**
 * StackElement
 */
class StackElement {
	/**
	 * @access public
	 * @var StackElement
	 */
	public $cause;
	/**
	 * @access public
	 * @var ArrayOfString
	 */
	public $wrappedContext;
}}

if (!class_exists("BaseException")) {
/**
 * BaseException
 */
class BaseException extends Exception{
	/**
	 * @access public
	 * @var StackElement
	 */
	public $stackElement;
}}

if (!class_exists("SystemException")) {
/**
 * SystemException
 */
class SystemException extends BaseException {
}}

if (!class_exists("BusinessException")) {
/**
 * BusinessException
 */
class BusinessException extends BaseException {
}}

if (!class_exists("findAddress")) {
/**
 * findAddress
 */
class findAddress {
	/**
	 * @access public
	 * @var Address
	 */
	public $Address_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findAddressResponse")) {
/**
 * findAddressResponse
 */
class findAddressResponse {
	/**
	 * @access public
	 * @var AddressResponse
	 */
	public $result;
}}

if (!class_exists("findAddresses")) {
/**
 * findAddresses
 */
class findAddresses {
	/**
	 * @access public
	 * @var ArrayOfAddress
	 */
	public $ArrayOfAddress_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findAddressesResponse")) {
/**
 * findAddressesResponse
 */
class findAddressesResponse {
	/**
	 * @access public
	 * @var ArrayOfAddressResponse
	 */
	public $result;
}}

if (!class_exists("findLocation")) {
/**
 * findLocation
 */
class findLocation {
	/**
	 * @access public
	 * @var Location
	 */
	public $Location_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findLocationResponse")) {
/**
 * findLocationResponse
 */
class findLocationResponse {
	/**
	 * @access public
	 * @var AddressResponse
	 */
	public $result;
}}

if (!class_exists("findLocations")) {
/**
 * findLocations
 */
class findLocations {
	/**
	 * @access public
	 * @var ArrayOfLocation
	 */
	public $ArrayOfLocation_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findLocationsResponse")) {
/**
 * findLocationsResponse
 */
class findLocationsResponse {
	/**
	 * @access public
	 * @var ArrayOfAddressResponse
	 */
	public $result;
}}

if (!class_exists("findPoiByAddress")) {
/**
 * findPoiByAddress
 */
class findPoiByAddress {
	/**
	 * @access public
	 * @var PoiAddress
	 */
	public $PoiAddress_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findPoiByAddressResponse")) {
/**
 * findPoiByAddressResponse
 */
class findPoiByAddressResponse {
	/**
	 * @access public
	 * @var PoiAddressResponse
	 */
	public $result;
}}

if (!class_exists("findPoiByAddresses")) {
/**
 * findPoiByAddresses
 */
class findPoiByAddresses {
	/**
	 * @access public
	 * @var ArrayOfPoiAddress
	 */
	public $ArrayOfPoiAddress_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findPoiByAddressesResponse")) {
/**
 * findPoiByAddressesResponse
 */
class findPoiByAddressesResponse {
	/**
	 * @access public
	 * @var ArrayOfPoiAddressResponse
	 */
	public $result;
}}

if (!class_exists("findPoiByLocation")) {
/**
 * findPoiByLocation
 */
class findPoiByLocation {
	/**
	 * @access public
	 * @var PoiLocation
	 */
	public $PoiLocation_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findPoiByLocationResponse")) {
/**
 * findPoiByLocationResponse
 */
class findPoiByLocationResponse {
	/**
	 * @access public
	 * @var PoiAddressResponse
	 */
	public $result;
}}

if (!class_exists("findPoiByLocations")) {
/**
 * findPoiByLocations
 */
class findPoiByLocations {
	/**
	 * @access public
	 * @var ArrayOfPoiLocation
	 */
	public $ArrayOfPoiLocation_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("findPoiByLocationsResponse")) {
/**
 * findPoiByLocationsResponse
 */
class findPoiByLocationsResponse {
	/**
	 * @access public
	 * @var ArrayOfPoiAddressResponse
	 */
	public $result;
}}

if (!class_exists("matchAddress")) {
/**
 * matchAddress
 */
class matchAddress {
	/**
	 * @access public
	 * @var Address
	 */
	public $Address_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("matchAddressResponse")) {
/**
 * matchAddressResponse
 */
class matchAddressResponse {
	/**
	 * @access public
	 * @var ArrayOfResultAddress
	 */
	public $result;
}}

if (!class_exists("matchAddresses")) {
/**
 * matchAddresses
 */
class matchAddresses {
	/**
	 * @access public
	 * @var ArrayOfAddress
	 */
	public $ArrayOfAddress_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("matchAddressesResponse")) {
/**
 * matchAddressesResponse
 */
class matchAddressesResponse {
	/**
	 * @access public
	 * @var ArrayOfArrayOfResultAddress
	 */
	public $result;
}}

if (!class_exists("matchLocation")) {
/**
 * matchLocation
 */
class matchLocation {
	/**
	 * @access public
	 * @var Point
	 */
	public $Point_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("matchLocationResponse")) {
/**
 * matchLocationResponse
 */
class matchLocationResponse {
	/**
	 * @access public
	 * @var ArrayOfResultAddress
	 */
	public $result;
}}

if (!class_exists("matchLocations")) {
/**
 * matchLocations
 */
class matchLocations {
	/**
	 * @access public
	 * @var ArrayOfPoint
	 */
	public $ArrayOfPoint_1;
	/**
	 * @access public
	 * @var ArrayOfSearchOptionBase
	 */
	public $ArrayOfSearchOptionBase_2;
	/**
	 * @access public
	 * @var ArrayOfSortOption
	 */
	public $ArrayOfSortOption_3;
	/**
	 * @access public
	 * @var ArrayOfResultField
	 */
	public $ArrayOfResultField_4;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_5;
}}

if (!class_exists("matchLocationsResponse")) {
/**
 * matchLocationsResponse
 */
class matchLocationsResponse {
	/**
	 * @access public
	 * @var ArrayOfArrayOfResultAddress
	 */
	public $result;
}}

if (!class_exists("SortOption")) {
/**
 * SortOption
 */
class SortOption extends TransientVO {
}}

if (!class_exists("SearchOptionBase")) {
/**
 * SearchOptionBase
 */
class SearchOptionBase extends TransientVO {
}}

if (!class_exists("AdditionalField")) {
/**
 * AdditionalField
 */
class AdditionalField extends TransientVO {
}}

if (!class_exists("XLocateException")) {
/**
 * XLocateException
 */
class XLocateException extends BusinessException {
}}

if (!class_exists("SearchOption")) {
/**
 * SearchOption
 */
class SearchOption extends SearchOptionBase {
}}

if (!class_exists("NamedSearchOption")) {
/**
 * NamedSearchOption
 */
class NamedSearchOption extends SearchOptionBase {
}}

if (!class_exists("Address")) {
/**
 * Address
 */
class Address extends TransientVO {
}}

if (!class_exists("ResultAddress")) {
/**
 * ResultAddress
 */
class ResultAddress extends Address {
	/**
	 * @access public
	 * @var ArrayOfAdditionalField
	 */
	public $wrappedAdditionalFields;
	/**
	 * @access public
	 * @var Point
	 */
	public $coordinates;
}}

if (!class_exists("ReverseSearchOption")) {
/**
 * ReverseSearchOption
 */
class ReverseSearchOption extends SearchOptionBase {
}}

if (!class_exists("PoiAddress")) {
/**
 * PoiAddress
 */
class PoiAddress extends Address {
}}

if (!class_exists("Location")) {
/**
 * Location
 */
class Location extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $coordinate;
}}

if (!class_exists("PoiLocation")) {
/**
 * PoiLocation
 */
class PoiLocation extends Location {
	/**
	 * @access public
	 * @var Polygon
	 */
	public $poiArea;
}}

if (!class_exists("PoiResultAddress")) {
/**
 * PoiResultAddress
 */
class PoiResultAddress extends ResultAddress {
}}

if (!class_exists("PoiSearchOption")) {
/**
 * PoiSearchOption
 */
class PoiSearchOption extends SearchOptionBase {
}}

if (!class_exists("AddressResponse")) {
/**
 * AddressResponse
 */
class AddressResponse extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfResultAddress
	 */
	public $wrappedResultList;
}}

if (!class_exists("PoiAddressResponse")) {
/**
 * PoiAddressResponse
 */
class PoiAddressResponse extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfPoiResultAddress
	 */
	public $wrappedResultList;
}}

if (!class_exists("RequestOptions")) {
/**
 * RequestOptions
 */
class RequestOptions extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfGeometryEncoding
	 */
	public $wrappedResponseGeometry;
}}

if (!class_exists("BoundingBox")) {
/**
 * BoundingBox
 */
class BoundingBox extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $leftTop;
	/**
	 * @access public
	 * @var Point
	 */
	public $rightBottom;
}}

if (!class_exists("XServiceException")) {
/**
 * XServiceException
 */
class XServiceException extends BusinessException {
}}

if (!class_exists("PlainGeometryBase")) {
/**
 * PlainGeometryBase
 */
class PlainGeometryBase extends TransientVO {
}}

if (!class_exists("PlainPoint")) {
/**
 * PlainPoint
 */
class PlainPoint extends PlainGeometryBase {
}}

if (!class_exists("EncodedGeometryBase")) {
/**
 * EncodedGeometryBase
 */
class EncodedGeometryBase extends TransientVO {
}}

if (!class_exists("CallerContext")) {
/**
 * CallerContext
 */
class CallerContext extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfCallerContextProperty
	 */
	public $wrappedProperties;
}}

if (!class_exists("CallerContextProperty")) {
/**
 * CallerContextProperty
 */
class CallerContextProperty extends TransientVO {
}}

if (!class_exists("AuditedVO")) {
/**
 * AuditedVO
 */
class AuditedVO extends VO {
}}

if (!class_exists("IllegalParameterException")) {
/**
 * IllegalParameterException
 */
class IllegalParameterException extends BusinessException {
}}

if (!class_exists("UnexpectedException")) {
/**
 * UnexpectedException
 */
class UnexpectedException extends SystemException {
}}

if (!class_exists("RemoteAccessException")) {
/**
 * RemoteAccessException
 */
class RemoteAccessException extends SystemException {
}}

if (!class_exists("EncodedGeometry")) {
/**
 * EncodedGeometry
 */
class EncodedGeometry extends EncodedGeometryBase {
}}

if (!class_exists("LinearRing")) {
/**
 * LinearRing
 */
class LinearRing extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainLinearRing
	 */
	public $linearRing;
}}

if (!class_exists("PlainLinearRing")) {
/**
 * PlainLinearRing
 */
class PlainLinearRing extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("Polygon")) {
/**
 * Polygon
 */
class Polygon extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainPolygon
	 */
	public $polygon;
}}

if (!class_exists("PlainPolygon")) {
/**
 * PlainPolygon
 */
class PlainPolygon extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainLinearRing
	 */
	public $wrappedLinearRings;
}}

if (!class_exists("LineString")) {
/**
 * LineString
 */
class LineString extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainLineString
	 */
	public $lineString;
}}

if (!class_exists("PlainLineString")) {
/**
 * PlainLineString
 */
class PlainLineString extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("Point")) {
/**
 * Point
 */
class Point extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainPoint
	 */
	public $point;
}}

if (!class_exists("PlainMultiPoint")) {
/**
 * PlainMultiPoint
 */
class PlainMultiPoint extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("PlainMultiLineString")) {
/**
 * PlainMultiLineString
 */
class PlainMultiLineString extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainLineString
	 */
	public $wrappedLineStrings;
}}

if (!class_exists("PlainMultiPolygon")) {
/**
 * PlainMultiPolygon
 */
class PlainMultiPolygon extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPolygon
	 */
	public $wrappedPolygons;
}}

if (!class_exists("PlainGeometryCollection")) {
/**
 * PlainGeometryCollection
 */
class PlainGeometryCollection extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainGeometryBase
	 */
	public $wrappedGeometries;
}}

if (!class_exists("MultiPoint")) {
/**
 * MultiPoint
 */
class MultiPoint extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiPoint
	 */
	public $multiPoint;
}}

if (!class_exists("MultiLineString")) {
/**
 * MultiLineString
 */
class MultiLineString extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiLineString
	 */
	public $multiLineString;
}}

if (!class_exists("MultiPolygon")) {
/**
 * MultiPolygon
 */
class MultiPolygon extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiPolygon
	 */
	public $multiPolygon;
}}

if (!class_exists("GeometryCollection")) {
/**
 * GeometryCollection
 */
class GeometryCollection extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainGeometryCollection
	 */
	public $geometryCollection;
}}

if (!class_exists("ParameterNotSetException")) {
/**
 * ParameterNotSetException
 */
class ParameterNotSetException extends IllegalParameterException {
}}

if (!class_exists("XLocateWSService")) {
/**
 * XLocateWSService
 * @author WSDLInterpreter
 */
class XLocateWSService extends SoapClient {
	/**
	 * Default class map for wsdl=>php
	 * @access private
	 * @var array
	 */
	private static $classmap = array(
		"SortOrder" => "SortOrder",
		"SortOption" => "SortOption",
		"TransientVO" => "TransientVO",
		"SearchOption" => "SearchOptionBase",
		"ClassificationDescription" => "ClassificationDescription",
		"AdditionalField" => "AdditionalField",
		"ResultField" => "ResultField",
		"SearchParameter" => "SearchParameter",
		"XLocateException" => "XLocateException",
		"BusinessException" => "BusinessException",
		"DetailLevelDescription" => "DetailLevelDescription",
		"SearchOption" => "SearchOption",
		"NamedSearchOption" => "NamedSearchOption",
		"Address" => "Address",
		"ResultAddress" => "ResultAddress",
		"ErrorCode" => "ErrorCode",
		"ReverseSearchParameter" => "ReverseSearchParameter",
		"ReverseSearchOption" => "ReverseSearchOption",
		"PoiAddress" => "PoiAddress",
		"Location" => "Location",
		"PoiLocation" => "PoiLocation",
		"PoiResultAddress" => "PoiResultAddress",
		"PoiSearchOption" => "PoiSearchOption",
		"PoiSearchParameter" => "PoiSearchParameter",
		"AddressResponse" => "AddressResponse",
		"PoiAddressResponse" => "PoiAddressResponse",
		"RequestOptions" => "RequestOptions",
		"GeometryEncoding" => "GeometryEncoding",
		"CoordFormat" => "CoordFormat",
		"BoundingBox" => "BoundingBox",
		"EncodedGeometry" => "EncodedGeometry",
		"EncodedGeometryBase" => "EncodedGeometryBase",
		"LinearRing" => "LinearRing",
		"PlainLinearRing" => "PlainLinearRing",
		"PlainGeometryBase" => "PlainGeometryBase",
		"Polygon" => "Polygon",
		"PlainPolygon" => "PlainPolygon",
		"LineString" => "LineString",
		"PlainLineString" => "PlainLineString",
		"Point" => "Point",
		"XServiceException" => "XServiceException",
		"PlainMultiPoint" => "PlainMultiPoint",
		"PlainMultiLineString" => "PlainMultiLineString",
		"PlainMultiPolygon" => "PlainMultiPolygon",
		"PlainGeometryCollection" => "PlainGeometryCollection",
		"MultiPoint" => "MultiPoint",
		"MultiLineString" => "MultiLineString",
		"MultiPolygon" => "MultiPolygon",
		"GeometryCollection" => "GeometryCollection",
		"PlainPoint" => "PlainPoint",
		"CallerContext" => "CallerContext",
		"CallerContextProperty" => "CallerContextProperty",
		"OID" => "OID",
		"AuditedVO" => "AuditedVO",
		"VO" => "VO",
		"StackElement" => "StackElement",
		"ParameterNotSetException" => "ParameterNotSetException",
		"IllegalParameterException" => "IllegalParameterException",
		"UnexpectedException" => "UnexpectedException",
		"SystemException" => "SystemException",
		"RemoteAccessException" => "RemoteAccessException",
		"BaseException" => "BaseException",
		"findAddress" => "findAddress",
		"findAddressResponse" => "findAddressResponse",
		"findAddresses" => "findAddresses",
		"findAddressesResponse" => "findAddressesResponse",
		"findLocation" => "findLocation",
		"findLocationResponse" => "findLocationResponse",
		"findLocations" => "findLocations",
		"findLocationsResponse" => "findLocationsResponse",
		"findPoiByAddress" => "findPoiByAddress",
		"findPoiByAddressResponse" => "findPoiByAddressResponse",
		"findPoiByAddresses" => "findPoiByAddresses",
		"findPoiByAddressesResponse" => "findPoiByAddressesResponse",
		"findPoiByLocation" => "findPoiByLocation",
		"findPoiByLocationResponse" => "findPoiByLocationResponse",
		"findPoiByLocations" => "findPoiByLocations",
		"findPoiByLocationsResponse" => "findPoiByLocationsResponse",
		"matchAddress" => "matchAddress",
		"matchAddressResponse" => "matchAddressResponse",
		"matchAddresses" => "matchAddresses",
		"matchAddressesResponse" => "matchAddressesResponse",
		"matchLocation" => "matchLocation",
		"matchLocationResponse" => "matchLocationResponse",
		"matchLocations" => "matchLocations",
		"matchLocationsResponse" => "matchLocationsResponse",
	);

	/**
	 * Constructor using wsdl location and options array
	 * @param string $wsdl WSDL location for this service
	 * @param array $options Options for the SoapClient
	 */
	public function __construct($wsdl="wsdl/XLocate.wsdl", $options=array()) {
		foreach(self::$classmap as $wsdlClassName => $phpClassName) {
		    if(!isset($options['classmap'][$wsdlClassName])) {
		        $options['classmap'][$wsdlClassName] = $phpClassName;
		    }
		}
		parent::__construct($wsdl, $options);
	}

	/**
	 * Checks if an argument list matches against a valid argument type list
	 * @param array $arguments The argument list to check
	 * @param array $validParameters A list of valid argument types
	 * @return boolean true if arguments match against validParameters
	 * @throws Exception invalid function signature message
	 */
	public function _checkArguments($arguments, $validParameters) {
		$variables = "";
		foreach ($arguments as $arg) {
		    $type = gettype($arg);
		    if ($type == "object") {
		        $type = get_class($arg);
		    }
		    $variables .= "(".$type.")";
		}
		if (!in_array($variables, $validParameters)) {
		    throw new Exception("Invalid parameter types: ".str_replace(")(", ", ", $variables));
		}
		return true;
	}

	/**
	 * Service Call: findAddress
	 * Parameter options:
	 * (findAddress) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findAddressResponse
	 * @throws Exception invalid function signature message
	 */
	public function findAddress($mixed = null) {
		$validParameters = array(
			"(findAddress)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findAddress", $args);
	}


	/**
	 * Service Call: findAddresses
	 * Parameter options:
	 * (findAddresses) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findAddressesResponse
	 * @throws Exception invalid function signature message
	 */
	public function findAddresses($mixed = null) {
		$validParameters = array(
			"(findAddresses)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findAddresses", $args);
	}


	/**
	 * Service Call: findLocation
	 * Parameter options:
	 * (findLocation) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findLocationResponse
	 * @throws Exception invalid function signature message
	 */
	public function findLocation($mixed = null) {
		$validParameters = array(
			"(findLocation)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findLocation", $args);
	}


	/**
	 * Service Call: findLocations
	 * Parameter options:
	 * (findLocations) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findLocationsResponse
	 * @throws Exception invalid function signature message
	 */
	public function findLocations($mixed = null) {
		$validParameters = array(
			"(findLocations)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findLocations", $args);
	}


	/**
	 * Service Call: findPoiByAddress
	 * Parameter options:
	 * (findPoiByAddress) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findPoiByAddressResponse
	 * @throws Exception invalid function signature message
	 */
	public function findPoiByAddress($mixed = null) {
		$validParameters = array(
			"(findPoiByAddress)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findPoiByAddress", $args);
	}


	/**
	 * Service Call: findPoiByAddresses
	 * Parameter options:
	 * (findPoiByAddresses) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findPoiByAddressesResponse
	 * @throws Exception invalid function signature message
	 */
	public function findPoiByAddresses($mixed = null) {
		$validParameters = array(
			"(findPoiByAddresses)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findPoiByAddresses", $args);
	}


	/**
	 * Service Call: findPoiByLocation
	 * Parameter options:
	 * (findPoiByLocation) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findPoiByLocationResponse
	 * @throws Exception invalid function signature message
	 */
	public function findPoiByLocation($mixed = null) {
		$validParameters = array(
			"(findPoiByLocation)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findPoiByLocation", $args);
	}


	/**
	 * Service Call: findPoiByLocations
	 * Parameter options:
	 * (findPoiByLocations) parameters
	 * @param mixed,... See function description for parameter options
	 * @return findPoiByLocationsResponse
	 * @throws Exception invalid function signature message
	 */
	public function findPoiByLocations($mixed = null) {
		$validParameters = array(
			"(findPoiByLocations)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("findPoiByLocations", $args);
	}


	/**
	 * Service Call: matchAddress
	 * Parameter options:
	 * (matchAddress) parameters
	 * @param mixed,... See function description for parameter options
	 * @return matchAddressResponse
	 * @throws Exception invalid function signature message
	 */
	public function matchAddress($mixed = null) {
		$validParameters = array(
			"(matchAddress)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("matchAddress", $args);
	}


	/**
	 * Service Call: matchAddresses
	 * Parameter options:
	 * (matchAddresses) parameters
	 * @param mixed,... See function description for parameter options
	 * @return matchAddressesResponse
	 * @throws Exception invalid function signature message
	 */
	public function matchAddresses($mixed = null) {
		$validParameters = array(
			"(matchAddresses)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("matchAddresses", $args);
	}


	/**
	 * Service Call: matchLocation
	 * Parameter options:
	 * (matchLocation) parameters
	 * @param mixed,... See function description for parameter options
	 * @return matchLocationResponse
	 * @throws Exception invalid function signature message
	 */
	public function matchLocation($mixed = null) {
		$validParameters = array(
			"(matchLocation)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("matchLocation", $args);
	}


	/**
	 * Service Call: matchLocations
	 * Parameter options:
	 * (matchLocations) parameters
	 * @param mixed,... See function description for parameter options
	 * @return matchLocationsResponse
	 * @throws Exception invalid function signature message
	 */
	public function matchLocations($mixed = null) {
		$validParameters = array(
			"(matchLocations)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("matchLocations", $args);
	}


}}

if (!class_exists("ImageFileFormat")) {
/**
 * ImageFileFormat
 */
class ImageFileFormat {
}}

if (!class_exists("TextAlignment")) {
/**
 * TextAlignment
 */
class TextAlignment {
}}

if (!class_exists("ErrorCodes")) {
/**
 * ErrorCodes
 */
class ErrorCodes {
}}

if (!class_exists("DrawPriorities")) {
/**
 * DrawPriorities
 */
class DrawPriorities {
}}

if (!class_exists("ObjectInfoType")) {
/**
 * ObjectInfoType
 */
class ObjectInfoType {
}}

if (!class_exists("DrawPositions")) {
/**
 * DrawPositions
 */
class DrawPositions {
}}

if (!class_exists("GeometryOptions")) {
/**
 * GeometryOptions
 */
class GeometryOptions {
}}

if (!class_exists("GeometryEncoding")) {
/**
 * GeometryEncoding
 */
class GeometryEncoding {
}}

if (!class_exists("CoordFormat")) {
/**
 * CoordFormat
 */
class CoordFormat {
}}

if (!class_exists("TransientVO")) {
/**
 * TransientVO
 */
class TransientVO {
}}

if (!class_exists("OID")) {
/**
 * OID
 */
class OID {
}}

if (!class_exists("VO")) {
/**
 * VO
 */
class VO {
}}

if (!class_exists("StackElement")) {
/**
 * StackElement
 */
class StackElement {
	/**
	 * @access public
	 * @var StackElement
	 */
	public $cause;
	/**
	 * @access public
	 * @var ArrayOfString
	 */
	public $wrappedContext;
}}

if (!class_exists("BaseException")) {
/**
 * BaseException
 */
class BaseException extends Exception {

	/**
	 * @access public
	 * @var StackElement
	 */
	public $stackElement;
}}

if (!class_exists("SystemException")) {
/**
 * SystemException
 */
class SystemException extends BaseException {
}}

if (!class_exists("BusinessException")) {
/**
 * BusinessException
 */
class BusinessException extends BaseException {
}}

if (!class_exists("renderMap")) {
/**
 * renderMap
 */
class renderMap {
	/**
	 * @access public
	 * @var MapSection
	 */
	public $MapSection_1;
	/**
	 * @access public
	 * @var MapParams
	 */
	public $MapParams_2;
	/**
	 * @access public
	 * @var ImageInfo
	 */
	public $ImageInfo_3;
	/**
	 * @access public
	 * @var ArrayOfLayer
	 */
	public $ArrayOfLayer_4;
	/**
	 * @access public
	 * @var boolean
	 */
	public $boolean_5;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_6;
}}

if (!class_exists("renderMapResponse")) {
/**
 * renderMapResponse
 */
class renderMapResponse {
	/**
	 * @access public
	 * @var Map
	 */
	public $result;
}}

if (!class_exists("renderMapBoundingBox")) {
/**
 * renderMapBoundingBox
 */
class renderMapBoundingBox {
	/**
	 * @access public
	 * @var BoundingBox
	 */
	public $BoundingBox_1;
	/**
	 * @access public
	 * @var MapParams
	 */
	public $MapParams_2;
	/**
	 * @access public
	 * @var ImageInfo
	 */
	public $ImageInfo_3;
	/**
	 * @access public
	 * @var ArrayOfLayer
	 */
	public $ArrayOfLayer_4;
	/**
	 * @access public
	 * @var boolean
	 */
	public $boolean_5;
	/**
	 * @access public
	 * @var CallerContext
	 */
	public $CallerContext_6;
}}

if (!class_exists("renderMapBoundingBoxResponse")) {
/**
 * renderMapBoundingBoxResponse
 */
class renderMapBoundingBoxResponse {
	/**
	 * @access public
	 * @var Map
	 */
	public $result;
}}

if (!class_exists("Map")) {
/**
 * Map
 */
class Map extends TransientVO {
	/**
	 * @access public
	 * @var Image
	 */
	public $image;
	/**
	 * @access public
	 * @var ArrayOfObjectInfos
	 */
	public $wrappedObjects;
	/**
	 * @access public
	 * @var VisibleSection
	 */
	public $visibleSection;
}}

if (!class_exists("MapSection")) {
/**
 * MapSection
 */
class MapSection extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $center;
}}

if (!class_exists("ImageInfo")) {
/**
 * ImageInfo
 */
class ImageInfo extends TransientVO {
}}

if (!class_exists("Layer")) {
/**
 * Layer
 */
class Layer extends TransientVO {
}}

if (!class_exists("StaticLayer")) {
/**
 * StaticLayer
 */
class StaticLayer extends Layer {
}}

if (!class_exists("CustomLayer")) {
/**
 * CustomLayer
 */
class CustomLayer extends Layer {
	/**
	 * @access public
	 * @var ArrayOfBitmaps
	 */
	public $wrappedBitmaps;
	/**
	 * @access public
	 * @var ArrayOfLines
	 */
	public $wrappedLines;
	/**
	 * @access public
	 * @var ArrayOfTexts
	 */
	public $wrappedTexts;
}}


if (!class_exists("BasicBitmap")) {
/**
 * BasicBitmap
 */
class BasicBitmap extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $position;
}}

if (!class_exists("Texts")) {
/**
 * Texts
 */
class Texts extends TransientVO {
	/**
	 * @access public
	 * @var TextOptions
	 */
	public $options;
	/**
	 * @access public
	 * @var ArrayOfText
	 */
	public $wrappedTexts;
}}

if (!class_exists("BitmapOptions")) {
/**
 * BitmapOptions
 */
class BitmapOptions extends TransientVO {
	/**
	 * @access public
	 * @var PlainPoint
	 */
	public $referencePoint;
	/**
	 * @access public
	 * @var Color
	 */
	public $transparencyColor;
}}

if (!class_exists("Color")) {
/**
 * Color
 */
class Color extends TransientVO {
}}

if (!class_exists("BasicDrawingOptions")) {
/**
 * BasicDrawingOptions
 */
class BasicDrawingOptions extends TransientVO {
	/**
	 * @access public
	 * @var Color
	 */
	public $color;
}}

if (!class_exists("Text")) {
/**
 * Text
 */
class Text extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $position;
}}

if (!class_exists("TextOptions")) {
/**
 * TextOptions
 */
class TextOptions extends TransientVO {
	/**
	 * @access public
	 * @var Color
	 */
	public $bgColor;
	/**
	 * @access public
	 * @var Font
	 */
	public $font;
	/**
	 * @access public
	 * @var Color
	 */
	public $frameColor;
	/**
	 * @access public
	 * @var Color
	 */
	public $textColor;
}}

if (!class_exists("Bitmaps")) {
/**
 * Bitmaps
 */
class Bitmaps extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfBasicBitmap
	 */
	public $wrappedBitmaps;
	/**
	 * @access public
	 * @var BitmapOptions
	 */
	public $options;
}}

if (!class_exists("Font")) {
/**
 * Font
 */
class Font extends TransientVO {
}}

if (!class_exists("Lines")) {
/**
 * Lines
 */
class Lines extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfLineString
	 */
	public $wrappedLines;
	/**
	 * @access public
	 * @var LineOptions
	 */
	public $options;
}}

if (!class_exists("ObjectInfos")) {
/**
 * ObjectInfos
 */
class ObjectInfos extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfLayerObject
	 */
	public $wrappedObjects;
}}

if (!class_exists("LayerObject")) {
/**
 * LayerObject
 */
class LayerObject extends TransientVO {
	/**
	 * @access public
	 * @var ObjectGeometry
	 */
	public $geometry;
	/**
	 * @access public
	 * @var PlainPoint
	 */
	public $pixel;
	/**
	 * @access public
	 * @var Point
	 */
	public $ref;
}}

if (!class_exists("Bitmap")) {
/**
 * Bitmap
 */
class Bitmap extends BasicBitmap {
}}

if (!class_exists("RawBitmap")) {
/**
 * RawBitmap
 */
class RawBitmap extends BasicBitmap {
}}

if (!class_exists("MapParams")) {
/**
 * MapParams
 */
class MapParams extends TransientVO {
}}

if (!class_exists("SMOLayer")) {
/**
 * SMOLayer
 */
class SMOLayer extends Layer {
}}

if (!class_exists("VisibleSection")) {
/**
 * VisibleSection
 */
class VisibleSection extends TransientVO {
	/**
	 * @access public
	 * @var BoundingBox
	 */
	public $boundingBox;
	/**
	 * @access public
	 * @var Point
	 */
	public $center;
}}

if (!class_exists("Image")) {
/**
 * Image
 */
class Image extends TransientVO {
}}

if (!class_exists("LineOptions")) {
/**
 * LineOptions
 */
class LineOptions extends TransientVO {
	/**
	 * @access public
	 * @var BasicDrawingOptions
	 */
	public $arrows;
	/**
	 * @access public
	 * @var LinePartOptions
	 */
	public $mainLine;
	/**
	 * @access public
	 * @var LinePartOptions
	 */
	public $sideLine;
}}

if (!class_exists("XMapException")) {
/**
 * XMapException
 */
class XMapException extends BusinessException {
}}

if (!class_exists("StaticPoiLayer")) {
/**
 * StaticPoiLayer
 */
class StaticPoiLayer extends StaticLayer {
}}

if (!class_exists("StaticRasterLayer")) {
/**
 * StaticRasterLayer
 */
class StaticRasterLayer extends StaticLayer {
}}

if (!class_exists("ObjectGeometry")) {
/**
 * ObjectGeometry
 */
class ObjectGeometry extends TransientVO {
	/**
	 * @access public
	 * @var PlainGeometryBase
	 */
	public $pixelGeometry;
	/**
	 * @access public
	 * @var EncodedGeometry
	 */
	public $refGeometry;
}}

if (!class_exists("GeometryLayer")) {
/**
 * GeometryLayer
 */
class GeometryLayer extends Layer {
	/**
	 * @access public
	 * @var ArrayOfGeometries
	 */
	public $wrappedGeometries;
}}

if (!class_exists("Geometries")) {
/**
 * Geometries
 */
class Geometries extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfGeometry
	 */
	public $wrappedGeometries;
	/**
	 * @access public
	 * @var ArrayOfGeometryOption
	 */
	public $wrappedOptions;
}}

if (!class_exists("GeometryOption")) {
/**
 * GeometryOption
 */
class GeometryOption extends TransientVO {
}}

if (!class_exists("Geometry")) {
/**
 * Geometry
 */
class Geometry extends TransientVO {
	/**
	 * @access public
	 * @var EncodedGeometry
	 */
	public $geometry;
	/**
	 * @access public
	 * @var Point
	 */
	public $referencePoint;
}}

if (!class_exists("RequestOptions")) {
/**
 * RequestOptions
 */
class RequestOptions extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfGeometryEncoding
	 */
	public $wrappedResponseGeometry;
}}

if (!class_exists("BoundingBox")) {
/**
 * BoundingBox
 */
class BoundingBox extends TransientVO {
	/**
	 * @access public
	 * @var Point
	 */
	public $leftTop;
	/**
	 * @access public
	 * @var Point
	 */
	public $rightBottom;
}}

if (!class_exists("XServiceException")) {
/**
 * XServiceException
 */
class XServiceException extends BusinessException {
}}

if (!class_exists("PlainGeometryBase")) {
/**
 * PlainGeometryBase
 */
class PlainGeometryBase extends TransientVO {
}}

if (!class_exists("PlainPoint")) {
/**
 * PlainPoint
 */
class PlainPoint extends PlainGeometryBase {
}}

if (!class_exists("EncodedGeometryBase")) {
/**
 * EncodedGeometryBase
 */
class EncodedGeometryBase extends TransientVO {
}}

if (!class_exists("CallerContext")) {
/**
 * CallerContext
 */
class CallerContext extends TransientVO {
	/**
	 * @access public
	 * @var ArrayOfCallerContextProperty
	 */
	public $wrappedProperties;
}}

if (!class_exists("CallerContextProperty")) {
/**
 * CallerContextProperty
 */
class CallerContextProperty extends TransientVO {
}}

if (!class_exists("AuditedVO")) {
/**
 * AuditedVO
 */
class AuditedVO extends VO {
}}

if (!class_exists("IllegalParameterException")) {
/**
 * IllegalParameterException
 */
class IllegalParameterException extends BusinessException {
}}

if (!class_exists("UnexpectedException")) {
/**
 * UnexpectedException
 */
class UnexpectedException extends SystemException {
}}

if (!class_exists("RemoteAccessException")) {
/**
 * RemoteAccessException
 */
class RemoteAccessException extends SystemException {
}}

if (!class_exists("LinePartOptions")) {
/**
 * LinePartOptions
 */
class LinePartOptions extends BasicDrawingOptions {
}}

if (!class_exists("EncodedGeometry")) {
/**
 * EncodedGeometry
 */
class EncodedGeometry extends EncodedGeometryBase {
}}

if (!class_exists("LinearRing")) {
/**
 * LinearRing
 */
class LinearRing extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainLinearRing
	 */
	public $linearRing;
}}

if (!class_exists("PlainLinearRing")) {
/**
 * PlainLinearRing
 */
class PlainLinearRing extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("Polygon")) {
/**
 * Polygon
 */
class Polygon extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainPolygon
	 */
	public $polygon;
}}

if (!class_exists("PlainPolygon")) {
/**
 * PlainPolygon
 */
class PlainPolygon extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainLinearRing
	 */
	public $wrappedLinearRings;
}}

if (!class_exists("LineString")) {
/**
 * LineString
 */
class LineString extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainLineString
	 */
	public $lineString;
}}

if (!class_exists("PlainLineString")) {
/**
 * PlainLineString
 */
class PlainLineString extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("Point")) {
/**
 * Point
 */
class Point extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainPoint
	 */
	public $point;
}}

if (!class_exists("PlainMultiPoint")) {
/**
 * PlainMultiPoint
 */
class PlainMultiPoint extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPoint
	 */
	public $wrappedPoints;
}}

if (!class_exists("PlainMultiLineString")) {
/**
 * PlainMultiLineString
 */
class PlainMultiLineString extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainLineString
	 */
	public $wrappedLineStrings;
}}

if (!class_exists("PlainMultiPolygon")) {
/**
 * PlainMultiPolygon
 */
class PlainMultiPolygon extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainPolygon
	 */
	public $wrappedPolygons;
}}

if (!class_exists("PlainGeometryCollection")) {
/**
 * PlainGeometryCollection
 */
class PlainGeometryCollection extends PlainGeometryBase {
	/**
	 * @access public
	 * @var ArrayOfPlainGeometryBase
	 */
	public $wrappedGeometries;
}}

if (!class_exists("MultiPoint")) {
/**
 * MultiPoint
 */
class MultiPoint extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiPoint
	 */
	public $multiPoint;
}}

if (!class_exists("MultiLineString")) {
/**
 * MultiLineString
 */
class MultiLineString extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiLineString
	 */
	public $multiLineString;
}}

if (!class_exists("MultiPolygon")) {
/**
 * MultiPolygon
 */
class MultiPolygon extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainMultiPolygon
	 */
	public $multiPolygon;
}}

if (!class_exists("GeometryCollection")) {
/**
 * GeometryCollection
 */
class GeometryCollection extends EncodedGeometry {
	/**
	 * @access public
	 * @var PlainGeometryCollection
	 */
	public $geometryCollection;
}}

if (!class_exists("ParameterNotSetException")) {
/**
 * ParameterNotSetException
 */
class ParameterNotSetException extends IllegalParameterException {
}}

if (!class_exists("XMapWSService")) {
/**
 * XMapWSService
 * @author WSDLInterpreter
 */
class XMapWSService extends SoapClient {
	/**
	 * Default class map for wsdl=>php
	 * @access private
	 * @var array
	 */
	private static $classmap = array(
		"ImageFileFormat" => "ImageFileFormat",
		"Map" => "Map",
		"TransientVO" => "TransientVO",
		"MapSection" => "MapSection",
		"ImageInfo" => "ImageInfo",
		"Layer" => "Layer",
		"StaticLayer" => "StaticLayer",
		"CustomLayer" => "CustomLayer",
		"BasicBitmap" => "BasicBitmap",
		"Texts" => "Texts",
		"BitmapOptions" => "BitmapOptions",
		"LinePartOptions" => "LinePartOptions",
		"BasicDrawingOptions" => "BasicDrawingOptions",
		"Color" => "Color",
		"Text" => "Text",
		"TextOptions" => "TextOptions",
		"Bitmaps" => "Bitmaps",
		"TextAlignment" => "TextAlignment",
		"Font" => "Font",
		"Lines" => "Lines",
		"ObjectInfos" => "ObjectInfos",
		"LayerObject" => "LayerObject",
		"Bitmap" => "Bitmap",
		"RawBitmap" => "RawBitmap",
		"MapParams" => "MapParams",
		"SMOLayer" => "SMOLayer",
		"VisibleSection" => "VisibleSection",
		"Image" => "Image",
		"ErrorCodes" => "ErrorCodes",
		"LineOptions" => "LineOptions",
		"XMapException" => "XMapException",
		"BusinessException" => "BusinessException",
		"DrawPriorities" => "DrawPriorities",
		"ObjectInfoType" => "ObjectInfoType",
		"StaticPoiLayer" => "StaticPoiLayer",
		"StaticRasterLayer" => "StaticRasterLayer",
		"DrawPositions" => "DrawPositions",
		"ObjectGeometry" => "ObjectGeometry",
		"GeometryLayer" => "GeometryLayer",
		"Geometries" => "Geometries",
		"GeometryOption" => "GeometryOption",
		"GeometryOptions" => "GeometryOptions",
		"Geometry" => "Geometry",
		"RequestOptions" => "RequestOptions",
		"GeometryEncoding" => "GeometryEncoding",
		"CoordFormat" => "CoordFormat",
		"BoundingBox" => "BoundingBox",
		"EncodedGeometry" => "EncodedGeometry",
		"EncodedGeometryBase" => "EncodedGeometryBase",
		"LinearRing" => "LinearRing",
		"PlainLinearRing" => "PlainLinearRing",
		"PlainGeometryBase" => "PlainGeometryBase",
		"Polygon" => "Polygon",
		"PlainPolygon" => "PlainPolygon",
		"LineString" => "LineString",
		"PlainLineString" => "PlainLineString",
		"Point" => "Point",
		"XServiceException" => "XServiceException",
		"PlainMultiPoint" => "PlainMultiPoint",
		"PlainMultiLineString" => "PlainMultiLineString",
		"PlainMultiPolygon" => "PlainMultiPolygon",
		"PlainGeometryCollection" => "PlainGeometryCollection",
		"MultiPoint" => "MultiPoint",
		"MultiLineString" => "MultiLineString",
		"MultiPolygon" => "MultiPolygon",
		"GeometryCollection" => "GeometryCollection",
		"PlainPoint" => "PlainPoint",
		"CallerContext" => "CallerContext",
		"CallerContextProperty" => "CallerContextProperty",
		"OID" => "OID",
		"AuditedVO" => "AuditedVO",
		"VO" => "VO",
		"StackElement" => "StackElement",
		"ParameterNotSetException" => "ParameterNotSetException",
		"IllegalParameterException" => "IllegalParameterException",
		"UnexpectedException" => "UnexpectedException",
		"SystemException" => "SystemException",
		"RemoteAccessException" => "RemoteAccessException",
		"BaseException" => "BaseException",
		"renderMap" => "renderMap",
		"renderMapResponse" => "renderMapResponse",
		"renderMapBoundingBox" => "renderMapBoundingBox",
		"renderMapBoundingBoxResponse" => "renderMapBoundingBoxResponse",
	);

	/**
	 * Constructor using wsdl location and options array
	 * @param string $wsdl WSDL location for this service
	 * @param array $options Options for the SoapClient
	 */
	public function __construct($wsdl="wsdl/XMap.wsdl", $options=array()) {
		foreach(self::$classmap as $wsdlClassName => $phpClassName) {
		    if(!isset($options['classmap'][$wsdlClassName])) {
		        $options['classmap'][$wsdlClassName] = $phpClassName;
		    }
		}
		parent::__construct($wsdl, $options);
	}

	/**
	 * Checks if an argument list matches against a valid argument type list
	 * @param array $arguments The argument list to check
	 * @param array $validParameters A list of valid argument types
	 * @return boolean true if arguments match against validParameters
	 * @throws Exception invalid function signature message
	 */
	public function _checkArguments($arguments, $validParameters) {
		$variables = "";
		foreach ($arguments as $arg) {
		    $type = gettype($arg);
		    if ($type == "object") {
		        $type = get_class($arg);
		    }
		    $variables .= "(".$type.")";
		}
		if (!in_array($variables, $validParameters)) {
		    throw new Exception("Invalid parameter types: ".str_replace(")(", ", ", $variables));
		}
		return true;
	}

	/**
	 * Service Call: renderMap
	 * Parameter options:
	 * (renderMap) parameters
	 * @param mixed,... See function description for parameter options
	 * @return renderMapResponse
	 * @throws Exception invalid function signature message
	 */
	public function renderMap($mixed = null) {
		$validParameters = array(
			"(renderMap)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("renderMap", $args);
	}


	/**
	 * Service Call: renderMapBoundingBox
	 * Parameter options:
	 * (renderMapBoundingBox) parameters
	 * @param mixed,... See function description for parameter options
	 * @return renderMapBoundingBoxResponse
	 * @throws Exception invalid function signature message
	 */
	public function renderMapBoundingBox($mixed = null) {
		$validParameters = array(
			"(renderMapBoundingBox)",
		);
		$args = func_get_args();
		$this->_checkArguments($args, $validParameters);
		return $this->__soapCall("renderMapBoundingBox", $args);
	}


}}

?>
