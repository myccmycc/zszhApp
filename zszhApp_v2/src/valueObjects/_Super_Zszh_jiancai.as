/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Zszh_jiancai.as.
 */

package valueObjects
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.EventDispatcher;
import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_Zszh_jiancai extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _Zszh_jiancaiEntityMetadata;
    model_internal var _changedObjects:mx.collections.ArrayCollection = new ArrayCollection();

    public function getChangedObjects() : Array
    {
        _changedObjects.addItemAt(this,0);
        return _changedObjects.source;
    }

    public function clearChangedObjects() : void
    {
        _changedObjects.removeAll();
    }

    /**
     * properties
     */
    private var _internal_resPath : String;
    private var _internal_id : int;
    private var _internal_resourcePath : String;
    private var _internal_ImgThumbnail : String;
    private var _internal_className : String;
    private var _internal_classArgument : String;
    private var _internal_objectName : String;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_Zszh_jiancai()
    {
        _model = new _Zszh_jiancaiEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get resPath() : String
    {
        return _internal_resPath;
    }

    [Bindable(event="propertyChange")]
    public function get id() : int
    {
        return _internal_id;
    }

    [Bindable(event="propertyChange")]
    public function get resourcePath() : String
    {
        return _internal_resourcePath;
    }

    [Bindable(event="propertyChange")]
    public function get ImgThumbnail() : String
    {
        return _internal_ImgThumbnail;
    }

    [Bindable(event="propertyChange")]
    public function get className() : String
    {
        return _internal_className;
    }

    [Bindable(event="propertyChange")]
    public function get classArgument() : String
    {
        return _internal_classArgument;
    }

    [Bindable(event="propertyChange")]
    public function get objectName() : String
    {
        return _internal_objectName;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set resPath(value:String) : void
    {
        var oldValue:String = _internal_resPath;
        if (oldValue !== value)
        {
            _internal_resPath = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "resPath", oldValue, _internal_resPath));
        }
    }

    public function set id(value:int) : void
    {
        var oldValue:int = _internal_id;
        if (oldValue !== value)
        {
            _internal_id = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "id", oldValue, _internal_id));
        }
    }

    public function set resourcePath(value:String) : void
    {
        var oldValue:String = _internal_resourcePath;
        if (oldValue !== value)
        {
            _internal_resourcePath = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "resourcePath", oldValue, _internal_resourcePath));
        }
    }

    public function set ImgThumbnail(value:String) : void
    {
        var oldValue:String = _internal_ImgThumbnail;
        if (oldValue !== value)
        {
            _internal_ImgThumbnail = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "ImgThumbnail", oldValue, _internal_ImgThumbnail));
        }
    }

    public function set className(value:String) : void
    {
        var oldValue:String = _internal_className;
        if (oldValue !== value)
        {
            _internal_className = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "className", oldValue, _internal_className));
        }
    }

    public function set classArgument(value:String) : void
    {
        var oldValue:String = _internal_classArgument;
        if (oldValue !== value)
        {
            _internal_classArgument = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "classArgument", oldValue, _internal_classArgument));
        }
    }

    public function set objectName(value:String) : void
    {
        var oldValue:String = _internal_objectName;
        if (oldValue !== value)
        {
            _internal_objectName = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "objectName", oldValue, _internal_objectName));
        }
    }

    /**
     * Data/source property setter listeners
     *
     * Each data property whose value affects other properties or the validity of the entity
     * needs to invalidate all previously calculated artifacts. These include:
     *  - any derived properties or constraints that reference the given data property.
     *  - any availability guards (variant expressions) that reference the given data property.
     *  - any style validations, message tokens or guards that reference the given data property.
     *  - the validity of the property (and the containing entity) if the given data property has a length restriction.
     *  - the validity of the property (and the containing entity) if the given data property is required.
     */


    /**
     * valid related derived properties
     */
    model_internal var _isValid : Boolean;
    model_internal var _invalidConstraints:Array = new Array();
    model_internal var _validationFailureMessages:Array = new Array();

    /**
     * derived property calculators
     */

    /**
     * isValid calculator
     */
    model_internal function calculateIsValid():Boolean
    {
        var violatedConsts:Array = new Array();
        var validationFailureMessages:Array = new Array();

        var propertyValidity:Boolean = true;

        model_internal::_cacheInitialized_isValid = true;
        model_internal::invalidConstraints_der = violatedConsts;
        model_internal::validationFailureMessages_der = validationFailureMessages;
        return violatedConsts.length == 0 && propertyValidity;
    }

    /**
     * derived property setters
     */

    model_internal function set isValid_der(value:Boolean) : void
    {
        var oldValue:Boolean = model_internal::_isValid;
        if (oldValue !== value)
        {
            model_internal::_isValid = value;
            _model.model_internal::fireChangeEvent("isValid", oldValue, model_internal::_isValid);
        }
    }

    /**
     * derived property getters
     */

    [Transient]
    [Bindable(event="propertyChange")]
    public function get _model() : _Zszh_jiancaiEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _Zszh_jiancaiEntityMetadata) : void
    {
        var oldValue : _Zszh_jiancaiEntityMetadata = model_internal::_dminternal_model;
        if (oldValue !== value)
        {
            model_internal::_dminternal_model = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_model", oldValue, model_internal::_dminternal_model));
        }
    }

    /**
     * methods
     */


    /**
     *  services
     */
    private var _managingService:com.adobe.fiber.services.IFiberManagingService;

    public function set managingService(managingService:com.adobe.fiber.services.IFiberManagingService):void
    {
        _managingService = managingService;
    }

    model_internal function set invalidConstraints_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_invalidConstraints;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_invalidConstraints = value;
            _model.model_internal::fireChangeEvent("invalidConstraints", oldValue, model_internal::_invalidConstraints);
        }
    }

    model_internal function set validationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_validationFailureMessages;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_validationFailureMessages = value;
            _model.model_internal::fireChangeEvent("validationFailureMessages", oldValue, model_internal::_validationFailureMessages);
        }
    }


}

}
