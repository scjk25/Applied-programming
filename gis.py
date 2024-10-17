# Import the necessary module
import arcpy

# Define the path to your ArcGIS Pro project (.aprx)
project_path = r"C:\Users\scott\OneDrive\Documents\ArcGIS\Projects\Temples\Temples.aprx"

# Open the ArcGIS project
aprx = arcpy.mp.ArcGISProject(project_path)

# Access the map containing the temple points (replace 'Map' with your map's name)
mymap = aprx.listMaps("Map")[0]

# Access the temples layer (replace 'Temples' with the actual name of your layer)
temple_layer = mymap.listLayers("Temples")[0]

# Enable pop-ups for the layer (this works for feature layers but doesn't give access to popupInfo directly)
temple_layer.showPopUps = True

# Now, let's access the symbology properties to prepare Arcade expressions
# Configure a new Arcade expression for pop-ups to show relevant information

# Arcade expression to display pop-up content
expression = """
var temple_name = $feature.TempleName;
var address = $feature.Address;
var year_dedicated = $feature.YearDedicated;
var status = $feature.Status;
return 'Temple: ' + temple_name + '\\n' +
       'Address: ' + address + '\\n' +
       'Year Dedicated: ' + year_dedicated + '\\n' +
       'Status: ' + status;
"""

# Create an expression info dictionary to attach to the layer
expression_info = {
    "name": "Temple_Info",
    "title": "Temple Details",
    "expression": expression
}

# Since we don't have direct access to popupInfo, we can work with expressionInfos to attach Arcade scripts
# Append the custom expression to the layer's existing properties if possible
# Use the layer's CIM (Cartographic Information Model) to make such changes in ArcGIS Pro
cim_layer = temple_layer.getDefinition("V2")
if not hasattr(cim_layer, "popupInfo"):
    cim_layer.popupInfo = {}

# Ensure there is a placeholder for expressions
if not cim_layer.popupInfo.get("expressionInfos"):
    cim_layer.popupInfo["expressionInfos"] = []

# Add the custom Arcade expression to the pop-up settings
cim_layer.popupInfo["expressionInfos"].append(expression_info)

# Apply the updated CIM definition back to the layer
temple_layer.setDefinition(cim_layer)

# Save the project after making changes
aprx.save()

# Cleanup
del aprx

print("Pop-up configuration complete.")