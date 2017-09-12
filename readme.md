Intelligent Thermostat
----------------------
The thermostat should control room temperature based on the time of day and the location of residents. Thermostats will be connected together in rooms and homes, so if a room has multiple radiators, they will all have the same temperature set point, and if all residents have left the home, the temperature in all rooms will be lowered. Whether residents are home will be determined based on the location of their smartphones. 
Rooms should be able to have different temperatures during day and night, so that eg. the temperature is lowered in the living room during night and in the bedroom during day.  
The goal is a “set and forget” device, meaning that ideally you will never have to touch the app or the thermostats after initial configuration. That means it should also include air out detection, to stop heating when windows or doors are open. This detection could be augmented by utilizing outdoor temperature measurements from an online weather service.  
The device might also include a photovoltaic cell (or alternatively a peltier element) to reduce or eliminate battery changes.  
The design philosophy is to have as simple a user experience as possible. The thermostat should be easily installable and simple to configure, with no central control unit.

While there are a lot of similar products in the market, this thermostat sets itself apart by having:
* Centralized control without a central control unit
* Potentially a much lower price point than comparable systems (low price bill of materials)
* A design goal of being simple, unintrusive and “set and forget” (in contrast to big control panels, painful programming, manually turning on/off remotely and similar features)
* Open software and hardware design

### Preliminary requirements:
1. Thermostat unit should be mountable on Danfoss type  RA radiator valve
2. Thermostat unit should be able to partially open the radiator valve in at least 20 steps
3. Thermostat unit should be able to completely close the radiator valve
4. Thermostat unit should be able to measure temperature in a resolution of 0.1 °C with +/- 0.5 °C precision in the range 0 - 30 °C
5. Thermostat unit should be able to regulate the temperature to within +/- 0.5 °C of the set point, measured as a 5 minute average (doors and windows closed, moderate ventilation)
6. Thermostat unit should have a battery life of minimum 6 months
7. Thermostat units communicate over wifi
8. The control app should be able to run on Android 4.4
9. Residents should be warned of low battery in a thermostat unit through the control app
10. Temperature can be set per room in the control app, with different settings for night and day
11. The hours for day and night can be configured in the control app
12. The time should be set automatically in the thermostat unit
13. Changing the temperature in a room changes the set point of all units belonging to that room
14. Changing the temperature in a room should take effect on all thermostat units after max. 5 minutes
15. When all registered resident smartphones are away from the home, the temperature is lowered in all rooms relatively to the distance to the nearest resident (beeline)
16. The temperature set point will never go below 5 °C
17. A registered resident smartphone that doesn’t report its position should be considered to approach the home at a configurable speed with default 50 km/h
18. Thermostat units should be able to detect an open window based on change in temperature, possibly taking into consideration outdoor temperature (to be specified further)
