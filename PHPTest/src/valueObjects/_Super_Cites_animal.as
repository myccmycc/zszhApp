/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Cites_animal.as.
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

[Managed]
[ExcludeClass]
public class _Super_Cites_animal extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _Cites_animalEntityMetadata;
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
    private var _internal_name_latin : String;
    private var _internal_name_cn : String;
    private var _internal_name_en : String;
    private var _internal_name_alias : String;
    private var _internal_cites_phylum : String;
    private var _internal_cites_class : String;
    private var _internal_cites_order : String;
    private var _internal_cites_family : String;
    private var _internal_cites_level : String;
    private var _internal_country_level : String;
    private var _internal_information : String;
    private var _internal_is_animal : String;
    private var _internal_id : int;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_Cites_animal()
    {
        _model = new _Cites_animalEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get name_latin() : String
    {
        return _internal_name_latin;
    }

    [Bindable(event="propertyChange")]
    public function get name_cn() : String
    {
        return _internal_name_cn;
    }

    [Bindable(event="propertyChange")]
    public function get name_en() : String
    {
        return _internal_name_en;
    }

    [Bindable(event="propertyChange")]
    public function get name_alias() : String
    {
        return _internal_name_alias;
    }

    [Bindable(event="propertyChange")]
    public function get cites_phylum() : String
    {
        return _internal_cites_phylum;
    }

    [Bindable(event="propertyChange")]
    public function get cites_class() : String
    {
        return _internal_cites_class;
    }

    [Bindable(event="propertyChange")]
    public function get cites_order() : String
    {
        return _internal_cites_order;
    }

    [Bindable(event="propertyChange")]
    public function get cites_family() : String
    {
        return _internal_cites_family;
    }

    [Bindable(event="propertyChange")]
    public function get cites_level() : String
    {
        return _internal_cites_level;
    }

    [Bindable(event="propertyChange")]
    public function get country_level() : String
    {
        return _internal_country_level;
    }

    [Bindable(event="propertyChange")]
    public function get information() : String
    {
        return _internal_information;
    }

    [Bindable(event="propertyChange")]
    public function get is_animal() : String
    {
        return _internal_is_animal;
    }

    [Bindable(event="propertyChange")]
    public function get id() : int
    {
        return _internal_id;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set name_latin(value:String) : void
    {
        var oldValue:String = _internal_name_latin;
        if (oldValue !== value)
        {
            _internal_name_latin = value;
        }
    }

    public function set name_cn(value:String) : void
    {
        var oldValue:String = _internal_name_cn;
        if (oldValue !== value)
        {
            _internal_name_cn = value;
        }
    }

    public function set name_en(value:String) : void
    {
        var oldValue:String = _internal_name_en;
        if (oldValue !== value)
        {
            _internal_name_en = value;
        }
    }

    public function set name_alias(value:String) : void
    {
        var oldValue:String = _internal_name_alias;
        if (oldValue !== value)
        {
            _internal_name_alias = value;
        }
    }

    public function set cites_phylum(value:String) : void
    {
        var oldValue:String = _internal_cites_phylum;
        if (oldValue !== value)
        {
            _internal_cites_phylum = value;
        }
    }

    public function set cites_class(value:String) : void
    {
        var oldValue:String = _internal_cites_class;
        if (oldValue !== value)
        {
            _internal_cites_class = value;
        }
    }

    public function set cites_order(value:String) : void
    {
        var oldValue:String = _internal_cites_order;
        if (oldValue !== value)
        {
            _internal_cites_order = value;
        }
    }

    public function set cites_family(value:String) : void
    {
        var oldValue:String = _internal_cites_family;
        if (oldValue !== value)
        {
            _internal_cites_family = value;
        }
    }

    public function set cites_level(value:String) : void
    {
        var oldValue:String = _internal_cites_level;
        if (oldValue !== value)
        {
            _internal_cites_level = value;
        }
    }

    public function set country_level(value:String) : void
    {
        var oldValue:String = _internal_country_level;
        if (oldValue !== value)
        {
            _internal_country_level = value;
        }
    }

    public function set information(value:String) : void
    {
        var oldValue:String = _internal_information;
        if (oldValue !== value)
        {
            _internal_information = value;
        }
    }

    public function set is_animal(value:String) : void
    {
        var oldValue:String = _internal_is_animal;
        if (oldValue !== value)
        {
            _internal_is_animal = value;
        }
    }

    public function set id(value:int) : void
    {
        var oldValue:int = _internal_id;
        if (oldValue !== value)
        {
            _internal_id = value;
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
    public function get _model() : _Cites_animalEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _Cites_animalEntityMetadata) : void
    {
        var oldValue : _Cites_animalEntityMetadata = model_internal::_dminternal_model;
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
