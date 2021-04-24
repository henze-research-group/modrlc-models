within ;
model wrapped "Wrapped model"
model SOM3 "Spawn replica of the Reference Small Office Building"

  // User input //
  String idfPat = "RefBldgSmallOfficeNew2004.idf";         // insert .idf file path
  String weaPat = "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw";         // insert  .mos file path

  //Parameters//
  Real OAInfCore = 0.121 "OA infiltration in the core zone";
  Real OAInfP1 = 0.089 "OA infiltration in the perimeter zone 1";
  Real OAInfP2 = 0.101 "OA infiltration in the perimeter zone 2";
  Real OAInfP3 = 0.089 "OA infiltration in the perimeter zone 3";
  Real OAInfP4 = 0.101 "OA infiltration in the perimeter zone 4";

  package Medium = Buildings.Media.Air "Moist Air"; // Moist air

  //Spawn//

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    usePrecompiledFMU=false,
    verbosity=Buildings.ThermalZones.EnergyPlus.Types.Verbosity.Verbose,
    showWeatherData=true,
    computeWetBulbTemperature=true,
    printUnits=true,
    generatePortableFMU=true)
    annotation (Placement(transformation(extent={{-274,72},{-254,92}})));

  Buildings.ThermalZones.EnergyPlus.ThermalZone corZon(
    zoneName="Core_ZN",                                redeclare final package
        Medium =                                                                        Medium,
      nPorts=2) "\"Core zone\""
    annotation (Placement(transformation(extent={{54,64},{94,104}})));

    // Fluids - non HVAC //
  Buildings.Fluid.Sources.Outside Outside(redeclare final package Medium = Medium,
      nPorts=10)
    "Outside environment boundary condition that uses the weather data from Spawn"
    annotation (Placement(transformation(extent={{-204,-2},{-184,18}})));

    // Fluids - HVAC //
    model ASHRAESystem3 "PZS-AC Constant Air Volume Packaged Single Zone Rooftop Unit"

      //Parameters - Fluids//
      parameter Modelica.SIunits.MassFlowRate mass_flow_nominal = 0.5 "Nominal Mass Flow Rate (kg/s)";
      parameter Modelica.SIunits.Pressure dp_nominal = 10 "Nominal Pressure Drop (Pa)";
      parameter Modelica.SIunits.Power heaNomPow = 100 "Gas Heater Nominal Power (W)";
      parameter Modelica.SIunits.Power CCNomPow = 100 "Cooling coil Nominal Power (W)";

      model System3RBControls "Rule-Based controls replicating those of the DOE Ref. Small Office Building"
        //Parameters //
        //Schedule//

        Real day "Day of the week (1: Mon, 7:Sun)";
        Real hou "Hour of the day (24-hour format)";
        parameter Real staOcc = 5 "Start of day (24-hour)";
        parameter Real stoOcc = 21 "End of day (24-hour)";    // staOcc and stoOcc are currently fixed (the RefBldgSmallOffice case has a simple schedule)
        parameter Real stoOccSat = 17 "End of day (24-hour)";
          //Setpoints//

        parameter Real heaOccSet = 273.15 + 21 "Heating setpoint for occupied mode";
        parameter Real heaNonOccSet = 273.15 + 15.6 "Heating setpoint for non occupied mode";
        parameter Real maxRH = 0.5 "Relative Humidity setpoint";
        parameter Real minOACCOpeTemp = 273.15 "Minimum outside air temperature for cooling coil operation";

        parameter Real cooOccSet = 273.15 + 24 "Cooling setpoint for occupied mode";
        parameter Real cooNonOccSet = 273.15 + 26.7 "Cooling setpoint for non occupied mode";

        parameter Real fanOccSet = 0.44 "Fan volumetric flow rate when operating (m3/s)";
        parameter Real fanMinVFR = 0.1 "Fan minimum volumetic flow rate (m3/s)";

        parameter Real damSetOcc = 0.3 "Mixing box OA volumetric flow rate - occupied mode (m3/s)";
        parameter Real damSetNonOcc = 0.08 "Minimum OA volumetric flow rate (m3/s)";
        parameter Real minOA = 0.08 "Minimum OA fraction (m3/s)";
        parameter Real minOAHVACOn = 0.2 "Minimum OA fraction (% total airflow), HVAC on (Ashrae 60.1)";
        parameter Real minOAHVACOff = 0.08 "Minimum OA fraction (m3/s), HVAC off (Ashrae 60.1)";

          //Controls//

        //parameter Real timShoCyc = 600 "Time constant for short cycling control (seconds)";
        //Boolean timRes "timer reset";

        // Inputs/Outputs//

        Modelica.Blocks.Interfaces.RealInput senTemRet annotation (Placement(
              transformation(extent={{-660,268},{-620,308}}),
                                                            iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-628,78})));
        Modelica.Blocks.Interfaces.RealOutput outDamSet annotation (Placement(
              transformation(extent={{662,124},{700,162}}),
                                                          iconTransformation(
              extent={{-19,-19},{19,19}},
              rotation=0,
              origin={713,-41})));
        Modelica.Blocks.Interfaces.RealOutput outHeaSet annotation (Placement(
              transformation(extent={{660,278},{698,316}}),
                                                          iconTransformation(
              extent={{-19,-19},{19,19}},
              rotation=0,
              origin={713,111})));

        // Control components //

        //Buildings.Controls.OBC.CDL.Logical.TimerAccumulating timerShortCycling(t=timShoCyc)
        //  annotation (Placement(transformation(extent={{32,4},{52,24}})));

        Modelica.Blocks.Interfaces.RealOutput outCCSet annotation (Placement(
              transformation(extent={{660,174},{698,212}}),
                                                          iconTransformation(
              extent={{-19,-19},{19,19}},
              rotation=0,
              origin={713,63})));
        Modelica.Blocks.Interfaces.RealInput senFanVFR annotation (Placement(
              transformation(extent={{-652,-260},{-612,-220}}),
                                                              iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-630,-46})));
        Modelica.Blocks.Interfaces.RealOutput outFanSet
                                                       annotation (Placement(
              transformation(extent={{660,232},{698,270}}),
                                                          iconTransformation(
              extent={{-19,-19},{19,19}},
              rotation=0,
              origin={713,15})));
        Modelica.Blocks.Interfaces.RealInput senDamVFR annotation (Placement(
              transformation(extent={{-650,-204},{-610,-164}}),iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-628,-166})));
        Modelica.Blocks.Interfaces.RealInput senTemOut annotation (Placement(
              transformation(extent={{-662,302},{-622,342}}),
                                                            iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-634,306})));

        //Modelica.Blocks.Sources.BooleanExpression boo1(y=timRes)
        //  annotation (Placement(transformation(extent={{-80,4},{-60,24}})));

        Modelica.Blocks.Interfaces.RealInput senHRRet annotation (Placement(
              transformation(extent={{-836,4},{-796,44}}),
              iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-630,-274})));
        Modelica.Blocks.Interfaces.RealInput senTemSup "\"Supply air temperature\""
          annotation (Placement(transformation(extent={{-840,138},{-800,178}}),
              iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=0,
              origin={-628,196})));
        Modelica.Blocks.Sources.RealExpression houIn(y=hou) "hour" annotation (
            Placement(transformation(extent={{-582,256},{-562,276}})));
        Modelica.Blocks.Sources.RealExpression dayIn(y=day) "day" annotation (
            Placement(transformation(extent={{-582,242},{-562,262}})));
        Modelica.Blocks.Sources.RealExpression coolingSetpointOccupied(y=
              cooOccSet) annotation (Placement(transformation(extent={{-282,200},{-262,
                  220}})));
        Modelica.Blocks.Sources.RealExpression coolingSetpointNonOccupied(y=
              cooNonOccSet) annotation (Placement(transformation(extent={{-282,184},{-262,
                  204}})));
        Modelica.Blocks.Sources.RealExpression fanSetpointOccupied(y=fanMinVFR)
          annotation (Placement(transformation(extent={{278,100},{298,120}})));
        Modelica.Blocks.Sources.RealExpression occStart(y=staOcc) annotation (
            Placement(transformation(extent={{-582,220},{-562,240}})));
        Modelica.Blocks.Sources.RealExpression occStop(y=stoOcc) annotation (
            Placement(transformation(extent={{-582,192},{-562,212}})));
        Modelica.Blocks.Sources.RealExpression occStopSat(y=stoOccSat)
          annotation (Placement(transformation(extent={{-582,162},{-562,182}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater staOccGre annotation (
            Placement(transformation(extent={{-492,228},{-472,248}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater stoOccGre annotation (
            Placement(transformation(extent={{-518,200},{-498,220}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater stoOccSatGre annotation (
            Placement(transformation(extent={{-518,170},{-498,190}})));
        Buildings.Controls.OBC.CDL.Logical.Not not1
          annotation (Placement(transformation(extent={{-490,200},{-470,220}})));
        Buildings.Controls.OBC.CDL.Logical.Not not2
          annotation (Placement(transformation(extent={{-490,170},{-470,190}})));
        Buildings.Controls.OBC.CDL.Logical.And houOccWeekdays annotation (
            Placement(transformation(extent={{-452,228},{-432,248}})));
        Buildings.Controls.OBC.CDL.Logical.And houOccSaturday annotation (
            Placement(transformation(extent={{-454,200},{-434,220}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater weekend annotation (
            Placement(transformation(extent={{-518,140},{-498,160}})));
        Modelica.Blocks.Sources.RealExpression fri(y=5) annotation (Placement(
              transformation(extent={{-582,132},{-562,152}})));
        Modelica.Blocks.Sources.RealExpression sat(y=6) annotation (Placement(
              transformation(extent={{-582,104},{-562,124}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater sunday annotation (
            Placement(transformation(extent={{-518,112},{-498,132}})));
        Buildings.Controls.OBC.CDL.Logical.And saturday annotation (Placement(
              transformation(extent={{-460,140},{-440,160}})));
        Buildings.Controls.OBC.CDL.Logical.Not not3
          annotation (Placement(transformation(extent={{-490,112},{-470,132}})));
        Buildings.Controls.OBC.CDL.Logical.Not not4
          annotation (Placement(transformation(extent={{-426,140},{-406,160}})));
        Buildings.Controls.OBC.CDL.Logical.And weekdays annotation (Placement(
              transformation(extent={{-400,120},{-380,140}})));
        Buildings.Controls.OBC.CDL.Logical.Switch cooSetpoint annotation (
            Placement(transformation(extent={{-222,192},{-202,212}})));
        Buildings.Controls.OBC.CDL.Logical.And occSaturday annotation (
            Placement(transformation(extent={{-370,200},{-350,220}})));
        Buildings.Controls.OBC.CDL.Logical.And occWeekday annotation (Placement(
              transformation(extent={{-370,228},{-350,248}})));
        Buildings.Controls.OBC.CDL.Logical.Or or2
          annotation (Placement(transformation(extent={{-340,208},{-320,228}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater neeCool(h=2)
          annotation (Placement(transformation(extent={{8,132},{28,152}})));
        Buildings.Controls.OBC.CDL.Logical.Timer tim(t=1800)
          annotation (Placement(transformation(extent={{84,80},{104,100}})));
        Buildings.Controls.OBC.CDL.Logical.Latch lat
          annotation (Placement(transformation(extent={{118,72},{138,92}})));
        Buildings.Controls.OBC.CDL.Logical.Not ccTurnedOff
          annotation (Placement(transformation(extent={{60,42},{80,62}})));
        Buildings.Controls.OBC.CDL.Logical.And and2
          annotation (Placement(transformation(extent={{152,132},{172,152}})));
        Buildings.Controls.OBC.CDL.Logical.Edge risEdgCC
          annotation (Placement(transformation(extent={{90,42},{110,62}})));
        Buildings.Controls.OBC.CDL.Logical.Not ccTurnedOff1 annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={162,118})));
        Buildings.Controls.OBC.CDL.Logical.Switch damSetLinear
          annotation (Placement(transformation(extent={{130,-74},{150,-54}})));
        Buildings.Controls.SetPoints.Table damSetTabHea(table=[cooOccSet - 1.5,0;
              cooOccSet,1])
          annotation (Placement(transformation(extent={{90,-58},{110,-38}})));
        Buildings.Controls.SetPoints.Table damSetTabHeaNonOcc(table=[
              cooNonOccSet - 1.5,0; cooNonOccSet,1])
          annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
        Buildings.Controls.OBC.CDL.Logical.Switch damSetLinear1
          annotation (Placement(transformation(extent={{162,-112},{182,-92}})));
        Buildings.Controls.OBC.CDL.Logical.Switch damSetLinear2
          annotation (Placement(transformation(extent={{130,-154},{150,-134}})));
        Buildings.Controls.SetPoints.Table damSetTabCoo(table=[heaOccSet,1;
              heaOccSet + 1.5,0])
          annotation (Placement(transformation(extent={{92,-136},{112,-116}})));
        Buildings.Controls.SetPoints.Table damSetTabCooNonOcc(table=[
              heaNonOccSet,1; heaNonOccSet + 1.5,0])
          annotation (Placement(transformation(extent={{92,-168},{112,-148}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater ecoHea(h=0.5)
          annotation (Placement(transformation(extent={{16,-112},{36,-92}})));
        Buildings.Controls.OBC.CDL.Logical.Or or1
          annotation (Placement(transformation(extent={{324,152},{344,172}})));
        Buildings.Controls.OBC.CDL.Logical.Switch fanSetLinear
          annotation (Placement(transformation(extent={{394,108},{414,128}})));
        Modelica.Blocks.Sources.RealExpression fanSetpointOccupied1(y=fanOccSet)
          annotation (Placement(transformation(extent={{362,116},{382,136}})));
        Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
          annotation (Placement(transformation(extent={{184,-6},{204,14}})));
        Buildings.Controls.OBC.CDL.Continuous.Feedback feedback
          annotation (Placement(transformation(extent={{440,108},{460,128}})));
        Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=10)
          annotation (Placement(transformation(extent={{478,108},{498,128}})));
        Buildings.Controls.OBC.CDL.Continuous.Add add2
          annotation (Placement(transformation(extent={{516,114},{536,134}})));
        Buildings.Controls.OBC.CDL.Logical.Pre pre
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=180,
              origin={122,118})));
        Buildings.Controls.OBC.CDL.Logical.And and1
          annotation (Placement(transformation(extent={{54,132},{74,152}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater cooOAChk(h=1)
          annotation (Placement(transformation(extent={{26,102},{46,122}})));
        Modelica.Blocks.Sources.RealExpression cooMinOATem(y=273.15 + 24)
        annotation (Placement(transformation(extent={{0,88},{20,108}})));
        Buildings.Controls.OBC.CDL.Logical.Switch heaSetpoint annotation (
            Placement(transformation(extent={{-222,238},{-202,258}})));
        Modelica.Blocks.Sources.RealExpression heatingSetpointNonOccupied(y=
              heaNonOccSet) annotation (Placement(transformation(extent={{-282,230},
                  {-262,250}})));
        Modelica.Blocks.Sources.RealExpression heatingSetpointOccupied(y=
              heaOccSet) annotation (Placement(transformation(extent={{-282,246},
                  {-262,266}})));
        Buildings.Controls.OBC.CDL.Continuous.Line lin
          annotation (Placement(transformation(extent={{98,288},{118,308}})));
        Modelica.Blocks.Sources.RealExpression minHeaCom(y=0)
          annotation (Placement(transformation(extent={{56,224},{76,244}})));
        Modelica.Blocks.Sources.RealExpression maxHeaCom(y=1)
          annotation (Placement(transformation(extent={{46,292},{66,312}})));
        Buildings.Controls.OBC.CDL.Continuous.Add add1
          annotation (Placement(transformation(extent={{40,314},{60,334}})));
        Modelica.Blocks.Sources.RealExpression heaOff(y=-8)
          annotation (Placement(transformation(extent={{6,320},{26,340}})));
        Buildings.Utilities.IO.SignalExchange.Overwrite oveCooSetpoint(u(
            unit="K",
            min=0,
            max=310), description="Cooling setpoint override")
          "\"BOPTEST override for the cooling setpoint\"" annotation (Placement(
              transformation(extent={{-186,190},{-166,210}})));
        Buildings.Utilities.IO.SignalExchange.Overwrite oveHeaSetpoint(u(
            unit="K",
            min=0,
            max=310), description="Heating setpoint override")
          "\"BOPTEST override for the heating setpoint\"" annotation (Placement(
              transformation(extent={{-186,238},{-166,258}})));
        Buildings.Controls.OBC.CDL.Logical.Switch OASetpoint
          annotation (Placement(transformation(extent={{128,-204},{148,-184}})));
        Modelica.Blocks.Sources.RealExpression fanSetpointNonOccupied1(y=minOAHVACOn*
              fanOccSet) annotation (Placement(transformation(extent={{90,-196},
                  {110,-176}})));
        Modelica.Blocks.Sources.RealExpression fanSetpointOccupied2(y=minOAHVACOff)
          annotation (Placement(transformation(extent={{90,-212},{110,-192}})));
        Buildings.Controls.OBC.CDL.Logical.Pre pre1
          annotation (Placement(transformation(extent={{50,-204},{70,-184}})));
        Buildings.Controls.OBC.CDL.Continuous.Add add3
          annotation (Placement(transformation(extent={{258,-198},{278,-178}})));
        Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=0.1)
          annotation (Placement(transformation(extent={{220,-204},{240,-184}})));
        Buildings.Controls.OBC.CDL.Continuous.Feedback feedback1
          annotation (Placement(transformation(extent={{182,-204},{202,-184}})));
        Buildings.Controls.OBC.CDL.Continuous.Limiter lim(uMax=1, uMin=0)
          annotation (Placement(transformation(extent={{300,-198},{320,-178}})));
        Buildings.Controls.OBC.CDL.Continuous.Max max1
          annotation (Placement(transformation(extent={{394,-148},{414,-128}})));
        Buildings.Controls.OBC.CDL.Continuous.Limiter lim1(uMax=1,    uMin=0)
          annotation (Placement(transformation(extent={{574,242},{594,262}})));
        Buildings.Utilities.IO.SignalExchange.Overwrite oveZeroCommands(u(
            unit="1",
            min=0,
            max=1), description="Zero command override")
          "\"BOPTEST override for setting all commands to 0\""
                                                          annotation (Placement(
              transformation(extent={{410,320},{430,340}})));
        Buildings.Controls.OBC.CDL.Logical.Switch staHea "heating start value"
          annotation (Placement(transformation(extent={{568,286},{588,306}})));
        Buildings.Controls.OBC.CDL.Logical.Switch staFan "fan start value"
          annotation (Placement(transformation(extent={{610,250},{630,270}})));
        Modelica.Blocks.Sources.RealExpression zeroStart(y=0)
          annotation (Placement(transformation(extent={{528,334},{548,354}})));
        Buildings.Controls.OBC.CDL.Logical.Switch staCC
          "Cooling coil start value"
          annotation (Placement(transformation(extent={{616,182},{636,202}})));
        Buildings.Controls.OBC.CDL.Logical.Switch staCC1
          "Cooling coil start value"
          annotation (Placement(transformation(extent={{616,134},{636,154}})));
        Buildings.Controls.OBC.CDL.Logical.Pre pre2(pre_u_start=true)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=0,
              origin={510,330})));
        Modelica.Blocks.Math.RealToBoolean reaToBooCC
          annotation (Placement(transformation(extent={{450,320},{470,340}})));
        Modelica.Blocks.Sources.RealExpression zeroStart1(y=0)
          annotation (Placement(transformation(extent={{358,316},{378,336}})));
        Buildings.Controls.OBC.CDL.Continuous.Greater gre(h=0.01)
          annotation (Placement(transformation(extent={{274,218},{294,238}})));
        Modelica.Blocks.Sources.RealExpression fanSetpointOccupied3(y=0.03)
          annotation (Placement(transformation(extent={{248,192},{268,212}})));
        Buildings.Controls.OBC.CDL.Logical.Or or3
          annotation (Placement(transformation(extent={{356,82},{376,102}})));
      equation

        //Setpoints - General//

        //connect(boo1.y, timerShortCycling.u)
        //  annotation (Line(points={{-59,14},{30,14}}, color={255,0,255}));
        connect(occStop.y, stoOccGre.u2)
          annotation (Line(points={{-561,202},{-520,202}},   color={0,0,127}));
        connect(occStopSat.y, stoOccSatGre.u2)
          annotation (Line(points={{-561,172},{-520,172}},   color={0,0,127}));
        connect(stoOccGre.y, not1.u) annotation (Line(points={{-496,210},{-492,210}},
                        color={255,0,255}));
        connect(stoOccSatGre.y, not2.u) annotation (Line(points={{-496,180},{-492,180}},
                             color={255,0,255}));
        connect(staOccGre.y, houOccWeekdays.u1) annotation (Line(points={{-470,238},{-454,
                238}},              color={255,0,255}));
        connect(not1.y, houOccWeekdays.u2) annotation (Line(points={{-468,210},{-466,210},
                {-466,230},{-454,230}},               color={255,0,255}));
        connect(stoOccGre.u1, houIn.y) annotation (Line(points={{-520,210},{-532,210},
                {-532,266},{-561,266}},              color={0,0,127}));
        connect(stoOccSatGre.u1, houIn.y) annotation (Line(points={{-520,180},{-532,180},
                {-532,266},{-561,266}},               color={0,0,127}));
        connect(occStart.y, staOccGre.u2)
          annotation (Line(points={{-561,230},{-494,230}},   color={0,0,127}));
        connect(staOccGre.u1, houIn.y) annotation (Line(points={{-494,238},{-532,238},
                {-532,266},{-561,266}},              color={0,0,127}));
        connect(houOccSaturday.u1, houOccWeekdays.u1) annotation (Line(points={{-456,210},
                {-460,210},{-460,238},{-454,238}},                color={255,0,
                255}));
        connect(not2.y, houOccSaturday.u2) annotation (Line(points={{-468,180},{-464,180},
                {-464,202},{-456,202}},               color={255,0,255}));
        connect(weekend.u1, dayIn.y) annotation (Line(points={{-520,150},{-542,150},{-542,
                252},{-561,252}},               color={0,0,127}));
        connect(sunday.u1, dayIn.y) annotation (Line(points={{-520,122},{-542,122},{-542,
                252},{-561,252}},               color={0,0,127}));
        connect(weekend.u2, fri.y)
          annotation (Line(points={{-520,142},{-561,142}},   color={0,0,127}));
        connect(sunday.u2, sat.y)
          annotation (Line(points={{-520,114},{-561,114}},   color={0,0,127}));
        connect(weekend.y, saturday.u1) annotation (Line(points={{-496,150},{-462,150}},
                             color={255,0,255}));
        connect(sunday.y, not3.u) annotation (Line(points={{-496,122},{-492,122}},
                        color={255,0,255}));
        connect(not3.y, saturday.u2) annotation (Line(points={{-468,122},{-464,122},{-464,
                142},{-462,142}},               color={255,0,255}));
        connect(saturday.y, not4.u) annotation (Line(points={{-438,150},{-428,150}},
                        color={255,0,255}));
        connect(not4.y, weekdays.u1) annotation (Line(points={{-404,150},{-404,130},{-402,
                130}},              color={255,0,255}));
        connect(weekdays.u2, saturday.u2) annotation (Line(points={{-402,122},{-464,122},
                {-464,142},{-462,142}},               color={255,0,255}));
        connect(houOccSaturday.y, occSaturday.u1) annotation (Line(points={{-432,210},
                {-372,210}},             color={255,0,255}));
        connect(houOccWeekdays.y, occWeekday.u1) annotation (Line(points={{-430,238},{
                -372,238}},         color={255,0,255}));
        connect(occWeekday.u2, weekdays.y) annotation (Line(points={{-372,230},{-376,230},
                {-376,130},{-378,130}},               color={255,0,255}));
        connect(occSaturday.u2, not4.u) annotation (Line(points={{-372,202},{-432,202},
                {-432,150},{-428,150}},              color={255,0,255}));
        connect(occWeekday.y, or2.u1) annotation (Line(points={{-348,238},{-346,238},{
                -346,218},{-342,218}},               color={255,0,255}));
        connect(occSaturday.y, or2.u2) annotation (Line(points={{-348,210},{-342,210}},
                             color={255,0,255}));
        connect(or2.y, cooSetpoint.u2) annotation (Line(points={{-318,218},{-286,
                218},{-286,202},{-224,202}},         color={255,0,255}));
        connect(cooSetpoint.u1, coolingSetpointOccupied.y)
          annotation (Line(points={{-224,210},{-261,210}},   color={0,0,127}));
        connect(cooSetpoint.u3, coolingSetpointNonOccupied.y)
          annotation (Line(points={{-224,194},{-261,194}},   color={0,0,127}));
        connect(neeCool.u1, senTemRet) annotation (Line(points={{6,142},{-20,142},
              {-20,288},{-640,288}},      color={0,0,127}));
        connect(risEdgCC.y, lat.clr) annotation (Line(points={{112,52},{112,76},
              {116,76}},           color={255,0,255}));
        connect(lat.y, and2.u2) annotation (Line(points={{140,82},{144,82},{144,134},{
                150,134}},   color={255,0,255}));
        connect(and2.y, ccTurnedOff1.u) annotation (Line(points={{174,142},{178,142},{
                178,118},{174,118}},
                                 color={255,0,255}));
        connect(ccTurnedOff.y, risEdgCC.u)
          annotation (Line(points={{82,52},{88,52}},        color={255,0,255}));
        connect(tim.passed, lat.u)
          annotation (Line(points={{106,82},{116,82}},     color={255,0,255}));
        connect(damSetTabHea.u, senTemRet) annotation (Line(points={{88,-48},{-20,
              -48},{-20,288},{-640,288}}, color={0,0,127}));
        connect(damSetTabHeaNonOcc.u, senTemRet) annotation (Line(points={{88,-80},
              {-20,-80},{-20,288},{-640,288}},       color={0,0,127}));
        connect(damSetTabHea.y, damSetLinear.u1) annotation (Line(points={{111,-48},{120,
                -48},{120,-56},{128,-56}},        color={0,0,127}));
        connect(damSetTabHeaNonOcc.y, damSetLinear.u3) annotation (Line(points={{111,-80},
                {119.5,-80},{119.5,-72},{128,-72}},    color={0,0,127}));
        connect(damSetTabCoo.y, damSetLinear2.u1) annotation (Line(points={{113,-126},
                {122,-126},{122,-136},{128,-136}}, color={0,0,127}));
        connect(damSetTabCooNonOcc.y, damSetLinear2.u3) annotation (Line(points={{113,
                -158},{121.5,-158},{121.5,-152},{128,-152}}, color={0,0,127}));
        connect(damSetTabCoo.u, senTemRet) annotation (Line(points={{90,-126},{-20,
              -126},{-20,288},{-640,288}},color={0,0,127}));
        connect(damSetTabCooNonOcc.u, senTemRet) annotation (Line(points={{90,-158},
              {-20,-158},{-20,288},{-640,288}},      color={0,0,127}));
        connect(ecoHea.u1, senTemRet) annotation (Line(points={{14,-102},{-20,-102},
              {-20,288},{-640,288}},      color={0,0,127}));
        connect(ecoHea.u2, senTemOut)
          annotation (Line(points={{14,-110},{-60,-110},{-60,322},{-642,322}},
                                                             color={0,0,127}));
        connect(damSetLinear.y, damSetLinear1.u1) annotation (Line(points={{152,-64},{
                154,-64},{154,-94},{160,-94}},     color={0,0,127}));
        connect(damSetLinear2.y, damSetLinear1.u3) annotation (Line(points={{152,-144},
                {156,-144},{156,-110},{160,-110}}, color={0,0,127}));
        connect(or1.u2, and2.y) annotation (Line(points={{322,154},{240,154},{240,142},
                {174,142}},color={255,0,255}));
        connect(fanSetpointOccupied1.y, fanSetLinear.u1) annotation (Line(points={{383,126},
                {392,126}},                                  color={0,0,127}));
        connect(booToRea.u, and2.y) annotation (Line(points={{182,4},{174,4},{174,90},
                {190,90},{190,142},{174,142}}, color={255,0,255}));
        connect(fanSetLinear.y, feedback.u1)
          annotation (Line(points={{416,118},{438,118}},   color={0,0,127}));
        connect(feedback.y, gai.u)
          annotation (Line(points={{462,118},{476,118}},   color={0,0,127}));
        connect(gai.y, add2.u2)
          annotation (Line(points={{500,118},{514,118}},   color={0,0,127}));
        connect(add2.u1, feedback.u1) annotation (Line(points={{514,130},{500,130},{500,
                144},{430,144},{430,118},{438,118}},         color={0,0,127}));
        connect(feedback.u2, senFanVFR) annotation (Line(points={{450,106},{450,-240},
                {-632,-240}}, color={0,0,127}));
        connect(ccTurnedOff1.y, pre.u)
          annotation (Line(points={{150,118},{134,118}}, color={255,0,255}));
        connect(pre.y, tim.u) annotation (Line(points={{110,118},{72,118},{72,
                90},{82,90}}, color={255,0,255}));
      connect(neeCool.y, and1.u1)
        annotation (Line(points={{30,142},{52,142}}, color={255,0,255}));
      connect(and1.y, and2.u1)
        annotation (Line(points={{76,142},{150,142}}, color={255,0,255}));
      connect(ccTurnedOff.u, and2.u1) annotation (Line(points={{58,52},{56,52},{
              56,82},{68,82},{68,130},{80,130},{80,142},{150,142}}, color={255,0,
              255}));
      connect(cooMinOATem.y, cooOAChk.u2) annotation (Line(points={{21,98},{22,98},
              {22,104},{24,104}}, color={0,0,127}));
      connect(cooOAChk.u1, senTemOut) annotation (Line(points={{24,112},{-60,112},
              {-60,322},{-642,322}}, color={0,0,127}));
      connect(cooOAChk.y, and1.u2) annotation (Line(points={{48,112},{52,112},{52,
              134},{52,134}}, color={255,0,255}));
        connect(ecoHea.y, damSetLinear1.u2)
          annotation (Line(points={{38,-102},{160,-102}}, color={255,0,255}));
        connect(heaSetpoint.u3, heatingSetpointNonOccupied.y)
          annotation (Line(points={{-224,240},{-261,240}}, color={0,0,127}));
        connect(heaSetpoint.u1, heatingSetpointOccupied.y)
          annotation (Line(points={{-224,256},{-261,256}}, color={0,0,127}));
        connect(heaSetpoint.u2, cooSetpoint.u2) annotation (Line(points={{-224,248},
                {-286,248},{-286,202},{-224,202}}, color={255,0,255}));
        connect(lin.f2, minHeaCom.y) annotation (Line(points={{96,290},{92,290},
                {92,234},{77,234}}, color={0,0,127}));
        connect(lin.f1, maxHeaCom.y)
          annotation (Line(points={{96,302},{67,302}}, color={0,0,127}));
        connect(add1.u1, heaOff.y)
          annotation (Line(points={{38,330},{27,330}}, color={0,0,127}));
        connect(add1.y, lin.x1) annotation (Line(points={{62,324},{80,324},{80,306},
                {96,306}}, color={0,0,127}));
        connect(lin.u, senTemRet) annotation (Line(points={{96,298},{76,298},{76,
                288},{-640,288}}, color={0,0,127}));
        connect(cooSetpoint.y, oveCooSetpoint.u)
          annotation (Line(points={{-200,202},{-194,202},{-194,200},{-188,200}},
                                                           color={0,0,127}));
        connect(heaSetpoint.y, oveHeaSetpoint.u)
          annotation (Line(points={{-200,248},{-188,248}}, color={0,0,127}));
        connect(add1.u2, lin.x2) annotation (Line(points={{38,318},{30,318},{30,
                254},{86,254},{86,294},{96,294}}, color={0,0,127}));
      connect(pre1.y,OASetpoint. u2)
        annotation (Line(points={{72,-194},{126,-194}}, color={255,0,255}));
        connect(feedback1.y,gai1. u)
          annotation (Line(points={{204,-194},{218,-194}}, color={0,0,127}));
        connect(gai1.y,add3. u2)
          annotation (Line(points={{242,-194},{256,-194}}, color={0,0,127}));
        connect(OASetpoint.y,feedback1. u1)
          annotation (Line(points={{150,-194},{180,-194}}, color={0,0,127}));
        connect(add3.u1,feedback1. u1) annotation (Line(points={{256,-182},{164,-182},
                {164,-194},{180,-194}}, color={0,0,127}));
        connect(add3.y,lim. u)
          annotation (Line(points={{280,-188},{298,-188}}, color={0,0,127}));
        connect(lim.y,max1. u2) annotation (Line(points={{322,-188},{358,-188},{358,-144},
                {392,-144}}, color={0,0,127}));
        connect(max1.u1, damSetLinear1.y) annotation (Line(points={{392,-132},{288,-132},
                {288,-102},{184,-102}}, color={0,0,127}));
        connect(senDamVFR, feedback1.u2) annotation (Line(points={{-630,-184},{-490,-184},
                {-490,-208},{192,-208},{192,-206}}, color={0,0,127}));
        connect(add2.y, lim1.u) annotation (Line(points={{538,124},{548,124},{548,
                252},{572,252}}, color={0,0,127}));
        connect(OASetpoint.u3, fanSetpointOccupied2.y)
          annotation (Line(points={{126,-202},{111,-202}}, color={0,0,127}));
        connect(OASetpoint.u1, fanSetpointNonOccupied1.y)
          annotation (Line(points={{126,-186},{111,-186}}, color={0,0,127}));
        connect(outHeaSet, staHea.y) annotation (Line(points={{679,297},{634,297},
                {634,296},{590,296}}, color={0,0,127}));
        connect(staHea.u3, lin.y) annotation (Line(points={{566,288},{398,288},{
                398,298},{120,298}}, color={0,0,127}));
        connect(lim1.y, staFan.u3)
          annotation (Line(points={{596,252},{608,252}}, color={0,0,127}));
        connect(zeroStart.y, staHea.u1) annotation (Line(points={{549,344},{558,
                344},{558,304},{566,304}}, color={0,0,127}));
        connect(staFan.u1, staHea.u1) annotation (Line(points={{608,268},{558,268},
                {558,304},{566,304}}, color={0,0,127}));
        connect(outCCSet, staCC.y) annotation (Line(points={{679,193},{658,193},
                {658,192},{638,192}}, color={0,0,127}));
        connect(staCC.u3, booToRea.y) annotation (Line(points={{614,184},{582,184},
                {582,4},{206,4}}, color={0,0,127}));
        connect(staCC.u1, staHea.u1) annotation (Line(points={{614,200},{558,200},
                {558,304},{566,304}}, color={0,0,127}));
        connect(outDamSet, staCC1.y) annotation (Line(points={{681,143},{660,143},
                {660,144},{638,144}}, color={0,0,127}));
        connect(staCC1.u1, staHea.u1) annotation (Line(points={{614,152},{558,152},
                {558,304},{566,304}}, color={0,0,127}));
        connect(pre2.y, staHea.u2) annotation (Line(points={{522,330},{542,330},
                {542,296},{566,296}}, color={255,0,255}));
        connect(staFan.u2, staHea.u2) annotation (Line(points={{608,260},{542,260},
                {542,296},{566,296}}, color={255,0,255}));
        connect(staCC.u2, staHea.u2) annotation (Line(points={{614,192},{542,192},
                {542,296},{566,296}}, color={255,0,255}));
        connect(staCC1.u2, staHea.u2) annotation (Line(points={{614,144},{542,144},
                {542,296},{566,296}}, color={255,0,255}));
        connect(pre2.u, reaToBooCC.y)
          annotation (Line(points={{498,330},{471,330}}, color={255,0,255}));
        connect(oveZeroCommands.y, reaToBooCC.u)
          annotation (Line(points={{431,330},{448,330}}, color={0,0,127}));
        connect(staFan.y, outFanSet) annotation (Line(points={{632,260},{652,
                260},{652,251},{679,251}}, color={0,0,127}));
        connect(zeroStart1.y, oveZeroCommands.u) annotation (Line(points={{379,
                326},{394,326},{394,330},{408,330}}, color={0,0,127}));
        connect(damSetLinear.u2, cooSetpoint.u2) annotation (Line(points={{128,-64},{-302,
                -64},{-302,218},{-286,218},{-286,202},{-224,202}}, color={255,0,255}));
        connect(damSetLinear2.u2, cooSetpoint.u2) annotation (Line(points={{128,-144},
                {-302,-144},{-302,218},{-286,218},{-286,202},{-224,202}}, color={255,0,
                255}));
        connect(gre.u2, fanSetpointOccupied3.y) annotation (Line(points={{272,220},{270,
                220},{270,202},{269,202}}, color={0,0,127}));
        connect(gre.u1, lin.y) annotation (Line(points={{272,228},{230,228},{230,298},
                {120,298}}, color={0,0,127}));
        connect(gre.y, or1.u1) annotation (Line(points={{296,228},{310,228},{310,162},
                {322,162}}, color={255,0,255}));
        connect(or1.y, pre1.u) annotation (Line(points={{346,162},{348,162},{
                348,-170},{38,-170},{38,-194},{48,-194}}, color={255,0,255}));
        connect(or3.u1, pre1.u) annotation (Line(points={{354,92},{348,132},{
                348,-170},{38,-170},{38,-194},{48,-194}}, color={255,0,255}));
        connect(or3.u2, cooSetpoint.u2) annotation (Line(points={{354,84},{26,
                84},{26,144},{-302,144},{-302,218},{-286,218},{-286,202},{-224,
                202}}, color={255,0,255}));
        connect(or3.y, fanSetLinear.u2) annotation (Line(points={{378,92},{386,
                92},{386,118},{392,118}}, color={255,0,255}));
        connect(fanSetpointOccupied.y, fanSetLinear.u3)
          annotation (Line(points={{299,110},{392,110}}, color={0,0,127}));
        connect(max1.y, staCC1.u3) annotation (Line(points={{416,-138},{614,-138},{614,
                136}}, color={0,0,127}));
        connect(oveHeaSetpoint.y, lin.x2) annotation (Line(points={{-165,248},{
                30,256},{30,254},{86,254},{86,294},{96,294}}, color={0,0,127}));
        connect(oveCooSetpoint.y, neeCool.u2) annotation (Line(points={{-165,
                200},{-76,200},{-76,134},{6,134}}, color={0,0,127}));
        annotation (Icon(coordinateSystem(extent={{-600,-300},{640,360}}),
                         graphics={Rectangle(extent={{-600,364},{642,-300}},
                  lineColor={28,108,200})}),Inline=true,GenerateEvents=true,
          Diagram(coordinateSystem(extent={{-600,-300},{640,360}}),
                  graphics={
              Rectangle(extent={{0,428},{212,182}},      lineColor={28,108,200}),
              Text(
                extent={{12,230},{112,184}},
                lineColor={28,108,200},
                textString="Heating"),
              Text(
                extent={{18,36},{118,-10}},
                lineColor={28,108,200},
                textString="Cooling"),
              Rectangle(extent={{2,170},{212,-16}},      lineColor={28,108,200}),
              Text(
                extent={{286,98},{386,52}},
                lineColor={28,108,200},
                textString="CV Fan controls"),
              Rectangle(extent={{274,194},{566,44}},    lineColor={28,108,200}),
              Text(
                extent={{-288,128},{-184,100}},
                lineColor={28,108,200},
                textString="Schedule"),
              Rectangle(extent={{-590,276},{-108,96}},    lineColor={28,108,200}),
              Text(
                extent={{8,-200},{108,-246}},
                lineColor={28,108,200},
                textString="Economizer"),
              Rectangle(extent={{4,-30},{212,-236}},     lineColor={28,108,200})}));
      end System3RBControls;

      //HVAC Components//

      Buildings.Fluid.Actuators.Dampers.MixingBox mixDam(
        use_inputFilter=true,
        riseTime=300,
        y_start=1,
      redeclare final package Medium = Medium,
        dpFixOut_nominal=3,
        dpFixRec_nominal=3,
        dpFixExh_nominal=3,
      from_dp=true,
      allowFlowReversal=true,
      mOut_flow_nominal=mass_flow_nominal,
      mRec_flow_nominal=mass_flow_nominal,
      mExh_flow_nominal=mass_flow_nominal,
      dpDamExh_nominal=3,
      dpDamOut_nominal=3,
      dpDamRec_nominal=100)        "Economizer: mixing box with damper"
      annotation (Placement(transformation(extent={{-274,-250},{-212,-188}})));

      Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed sinSpeDX(
        redeclare final package Medium = Medium,
        datCoi(
          nSta=1,
          minSpeRat=0.2,
          sta={
              Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
              spe=1800/60,
              nomVal=
                Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
                Q_flow_nominal=CCNomPow,
                COP_nominal=3.67,
                SHR_nominal=0.79,
                m_flow_nominal=0.53,
                TEvaIn_nominal=273.15 + 17.74,
                TConIn_nominal=308.15,
                phiIn_nominal=0.48,
                tWet=1200),
              perCur=
                Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.PerformanceCurve(
                capFunT={0.9712123,-0.015275502,0.0014434524,-0.00039321,-0.0000068364,
                  -0.0002905956},
                capFunFF={1,0,0},
                EIRFunT={0.28687133,0.023902164,-0.000810648,0.013458546,0.0003389364,
                  -0.0004870044},
                EIRFunFF={1,0,0},
                TConInMin=291.15,
                TConInMax=319.26111,
                TEvaInMin=285.92778,
                TEvaInMax=297.03889,
                ffMin=0.5,
                ffMax=1.5))}),
        allowFlowReversal=true,
        m_flow_small=1E-3,
        from_dp=false,
      dp_nominal=150,
      T_start=288.65)   "Single Speed DX cooling coil"
        annotation (Placement(transformation(extent={{-98,-114},{-40,-56}})));

      Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
        redeclare final package Medium = Medium,
        allowFlowReversal=true,
        m_flow_nominal=mass_flow_nominal,
      dp_nominal=150,
      T_start=288.65,
        Q_flow_nominal=heaNomPow)
        annotation (Placement(transformation(extent={{80,-106},{118,-64}})));

      // TO DO: replace fan characteristics values by variable parameters//

      Buildings.Fluid.Movers.FlowControlled_m_flow fan(
        redeclare final package Medium = Medium,
        T_start=288.65,
        allowFlowReversal=true,
        m_flow_nominal=mass_flow_nominal,
        per(
          pressure(V_flow={0.4399,0.44}, dp={622.1,622}),
          use_powerCharacteristic=false,
          hydraulicEfficiency(V_flow={0.44}, eta={0.65}),
          motorEfficiency(V_flow={0.44}, eta={0.825})),
        riseTime=300,
        dp_nominal=622)
        annotation (Placement(transformation(extent={{190,-106},{232,-64}})));

      // Ports //

     Modelica.Blocks.Interfaces.RealInput day annotation (Placement(transformation(
              extent={{-440,90},{-400,130}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-396,-140})));
      Modelica.Blocks.Interfaces.RealInput hour annotation (Placement(
            transformation(extent={{-440,130},{-400,170}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-396,-214})));

      Modelica.Fluid.Interfaces.FluidPort_a OAInlPor(redeclare final package
          Medium =
          Medium) "Port to the outside air source" annotation (Placement(
          transformation(extent={{-410,-210},{-390,-190}}),
                                                        iconTransformation(
            extent={{-420,280},{-400,300}})));

      Modelica.Fluid.Interfaces.FluidPort_b OAOutPor(redeclare final package
          Medium =
          Medium) "Port to the outside air sink" annotation (Placement(
          transformation(extent={{-410,-248},{-390,-228}}),
                                                         iconTransformation(
            extent={{-420,18},{-400,38}})));

      Modelica.Fluid.Interfaces.FluidPort_b zonSupPort(redeclare final package
          Medium =
          Medium) "Outlet to the zone air supply" annotation (Placement(
          transformation(extent={{436,-168},{456,-148}}),
                                                      iconTransformation(extent=
             {{600,280},{620,300}})));

      Modelica.Fluid.Interfaces.FluidPort_a zonRetPor(redeclare final package
          Medium =
          Medium) "Inlet for the zone return air" annotation (Placement(
          transformation(extent={{442,-248},{462,-228}}),
                                                       iconTransformation(
            extent={{602,20},{622,40}})));

     //Controls//

      Buildings.Fluid.Sensors.VolumeFlowRate volSenSup(
        redeclare final package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65) "Volumetric flow rate sensor, supply side"
        annotation (Placement(transformation(extent={{346,-94},{366,-74}})));

      Buildings.Fluid.Sensors.VolumeFlowRate volSenOA(
        redeclare final package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65) "Volumetric flow rate sensor, outside air"
        annotation (Placement(transformation(extent={{-316,-210},{-296,-190}})));

      //Output //

      Modelica.Blocks.Interfaces.RealOutput fanPowDem "Fan power demand"
       annotation (Placement(transformation(extent={{442,-28},{486,16}}),
          iconTransformation(
          extent={{-22,-22},{22,22}},
          rotation=270,
          origin={236,-284})));

      Modelica.Blocks.Interfaces.RealOutput heaPowDem
      "Heating coil power demand" annotation (Placement(transformation(extent={{442,38},
                {486,82}}),         iconTransformation(
          extent={{-22,-22},{22,22}},
          rotation=270,
          origin={332,-284})));

      Modelica.Blocks.Interfaces.RealOutput cooPowDem
      "Cooling coil power demand" annotation (Placement(transformation(extent={{442,100},
                {486,144}}),        iconTransformation(
          extent={{-22,-22},{22,22}},
          rotation=270,
          origin={438,-284})));

      // Signal Exchange blocks - BOPTEST //

      Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet(u(
          unit="1",
          min=0,
          max=1), description="Heating Coil setpoint override")
        "\"BOPTEST override for the HC control\""
        annotation (Placement(transformation(extent={{-226,42},{-206,62}})));
      Buildings.Utilities.IO.SignalExchange.Overwrite oveCCSet(u(
          unit="1",
          min=0,
          max=1), description="Cooling Coil setpoint override")
        "\"BOPTEST override for the CC control"
        annotation (Placement(transformation(extent={{-226,10},{-206,30}})));
      Buildings.Utilities.IO.SignalExchange.Overwrite oveFanSet(u(
          unit="1",
          min=0,
          max=2), description="Fan setpoint override")
        "\"BOPTEST override for the fan control"
        annotation (Placement(transformation(extent={{-226,-26},{-206,-6}})));
      Buildings.Utilities.IO.SignalExchange.Overwrite oveDamSet(u(
          unit="1",
          min=0,
          max=1), description="Damper setpoint override")
        "\"BOPTEST override for the mixing box control"
        annotation (Placement(transformation(extent={{-226,-62},{-206,-42}})));

      Modelica.Blocks.Interfaces.RealInput senTemOA annotation (Placement(
            transformation(extent={{-434,-96},{-394,-56}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-398,-52})));
      Modelica.Blocks.Math.RealToBoolean reaToBooCC
        annotation (Placement(transformation(extent={{-186,10},{-166,30}})));

    Buildings.Utilities.IO.SignalExchange.Read senTemRoo(y(min=260.0, max=310.0, unit="K"), description=
          "Room return temperature", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-406,6})));
      Modelica.Blocks.Interfaces.RealInput temSenRet
                                                    annotation (Placement(
            transformation(extent={{-434,-138},{-394,-98}}),iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=180,
            origin={578,358})));
      Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare
          final package Medium =                                                               Medium,
        allowFlowReversal=true,
          m_flow_nominal=0.5,
        m_flow_small=0.0001)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=180,
            origin={90,-238})));
    Buildings.Utilities.IO.SignalExchange.Read senRelHumOut(description="Room HR",
          KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.RelativeHumidity, y(min=0.0, max=1.0, unit="1"))
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={38,-132})));
    Buildings.Utilities.IO.SignalExchange.Read senVolOA(description="OA VFR",
          KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(min=0.0, max=2.0, unit="m3/s"))
        "\"OA volumetric flowrate sensor\"" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-336,-174})));
    Buildings.Utilities.IO.SignalExchange.Read senVolSup(description="Supply VFR",
          KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(min=0.0, max=2.0, unit="m3/s"))
        "\"Supply volumetric flowrate sensor\"" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-274,-156})));
      Buildings.Fluid.Sensors.TemperatureTwoPort senTSup(
        redeclare final package Medium = Medium,
        allowFlowReversal=true,
        m_flow_nominal=0.5,
        T_start=288.75) "\"Supply air temperature\""
        annotation (Placement(transformation(extent={{384,-94},{404,-74}})));
    Buildings.Utilities.IO.SignalExchange.Read senTemSup(
        y(min=275.0,
          max=340.0,
          unit="K"),
        description="Supply air temperature",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
        "\"Supply air temperature\"" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-406,40})));
      System3RBControls controls(
        day=day,
        hou=hour,
        minOACCOpeTemp=280,
        minOA=0.2)                                    "CAV controller"
      annotation (Placement(transformation(extent={{-316,4},{-290,52}})));
      Buildings.Fluid.FixedResistances.PressureDrop
                                    res(
      redeclare package Medium = Medium,
      m_flow_nominal=mass_flow_nominal,
        dp_nominal=150)
                      "Pressure drop"
        annotation (Placement(transformation(extent={{266,-84},{286,-64}})));
    equation

    connect(mixDam.port_Sup, sinSpeDX.port_a) annotation (Line(points={{-212,-200.4},
              {-200,-200.4},{-200,-85},{-98,-85}},
                                               color={0,127,255}));
      connect(sinSpeDX.port_b, hea.port_a)
        annotation (Line(points={{-40,-85},{80,-85}},          color={0,127,255}));
      connect(hea.port_b, fan.port_a)
        annotation (Line(points={{118,-85},{190,-85}}, color={0,127,255}));
    connect(OAOutPor, mixDam.port_Exh) annotation (Line(points={{-400,-238},{-304,-238},
              {-304,-237.6},{-274,-237.6}},  color={0,127,255}));
    connect(fan.P, fanPowDem) annotation (Line(points={{234.1,-66.1},{234.1,-46},
            {284,-46},{284,-6},{464,-6}},   color={0,0,127}));
    connect(fanPowDem, fanPowDem)
      annotation (Line(points={{464,-6},{464,-6}},   color={0,0,127}));
    connect(hea.Q_flow, heaPowDem) annotation (Line(points={{119.9,-72.4},{136,-72.4},
              {136,60},{464,60}}, color={0,0,127}));
    connect(cooPowDem, sinSpeDX.P) annotation (Line(points={{464,122},{22,122},{22,-58.9},
              {-37.1,-58.9}},         color={0,0,127}));
      connect(OAInlPor, volSenOA.port_a)
        annotation (Line(points={{-400,-200},{-316,-200}}, color={0,127,255}));
      connect(volSenOA.port_b, mixDam.port_Out) annotation (Line(points={{-296,-200},
              {-290,-200},{-290,-200.4},{-274,-200.4}}, color={0,127,255}));
      connect(oveHCSet.y, hea.u) annotation (Line(points={{-205,52},{48,52},{48,-72.4},
              {76.2,-72.4}}, color={0,0,127}));
      connect(oveFanSet.y, fan.m_flow_in) annotation (Line(points={{-205,-16},{211,
            -16},{211,-59.8}},
                            color={0,0,127}));
      connect(oveDamSet.y, mixDam.y) annotation (Line(points={{-205,-52},{-198,-52},
              {-198,-68},{-243,-68},{-243,-181.8}}, color={0,0,127}));
      connect(oveCCSet.y, reaToBooCC.u)
        annotation (Line(points={{-205,20},{-188,20}}, color={0,0,127}));
      connect(reaToBooCC.y, sinSpeDX.on) annotation (Line(points={{-165,20},{-132,20},
              {-132,-61.8},{-100.9,-61.8}}, color={255,0,255}));
      connect(temSenRet, senTemRoo.u) annotation (Line(points={{-414,-118},{-418,
              -118},{-418,6},{-418,6}}, color={0,0,127}));
      connect(senRelHum.phi, senRelHumOut.u) annotation (Line(points={{89.9,-249},{70.05,
              -249},{70.05,-132},{50,-132}},        color={0,0,127}));
      connect(senRelHum.port_b, mixDam.port_Ret) annotation (Line(points={{80,
              -238},{-66,-238},{-66,-237.6},{-212,-237.6}}, color={0,127,255}));
      connect(senRelHum.port_a, zonRetPor) annotation (Line(points={{100,-238},
              {276,-238},{276,-238},{452,-238}}, color={0,127,255}));
      connect(volSenOA.V_flow, senVolOA.u) annotation (Line(points={{-306,-189},
              {-306,-174},{-324,-174}}, color={0,0,127}));
      connect(volSenSup.V_flow, senVolSup.u) annotation (Line(points={{356,-73},
              {356,-64},{312,-64},{312,-156},{-262,-156}}, color={0,0,127}));
      connect(sinSpeDX.TConIn, senTemOA) annotation (Line(points={{-100.9,-76.3},{-382,
              -76.3},{-382,-76},{-414,-76}}, color={0,0,127}));
      connect(zonSupPort, senTSup.port_b) annotation (Line(points={{446,-158},{426,-158},
              {426,-84},{404,-84}}, color={0,127,255}));
      connect(volSenSup.port_b, senTSup.port_a)
        annotation (Line(points={{366,-84},{384,-84}}, color={0,127,255}));
      connect(controls.outHeaSet, oveHCSet.u) annotation (Line(points={{
              -288.469,33.8909},{-259.235,33.8909},{-259.235,52},{-228,52}},
                                                           color={0,0,127}));
      connect(controls.outCCSet, oveCCSet.u) annotation (Line(points={{-288.469,
              30.4},{-258.235,30.4},{-258.235,20},{-228,20}},
                                                        color={0,0,127}));
      connect(controls.outFanSet, oveFanSet.u) annotation (Line(points={{
              -288.469,26.9091},{-259.235,26.9091},{-259.235,-16},{-228,-16}},
                                                             color={0,0,127}));
      connect(controls.outDamSet, oveDamSet.u) annotation (Line(points={{
              -288.469,22.8364},{-288.469,-34.5818},{-228,-34.5818},{-228,-52}},
                                                               color={0,0,127}));
      connect(controls.senTemOut, senTemOA) annotation (Line(points={{-316.713,
              48.0727},{-316.713,48},{-346,48},{-346,-14},{-414,-14},{-414,-76}},
                                                                         color={0,0,
              127}));
      connect(controls.senTemSup, senTemSup.y) annotation (Line(points={{
              -316.587,40.0727},{-316.587,41.0363},{-395,41.0363},{-395,40}},
                                                            color={0,0,127}));
      connect(controls.senTemRet, senTemRoo.y) annotation (Line(points={{
              -316.587,31.4909},{-355.293,31.4909},{-355.293,6},{-395,6}},
                                                         color={0,0,127}));
      connect(controls.senFanVFR, senVolSup.y) annotation (Line(points={{
              -316.629,22.4727},{-334,22.4727},{-334,-156},{-285,-156}},
                                                       color={0,0,127}));
      connect(controls.senDamVFR, senVolOA.y) annotation (Line(points={{
              -316.587,13.7455},{-344,13.7455},{-344,-106},{-366,-106},{-366,
              -174},{-347,-174}},
            color={0,0,127}));
      connect(controls.senHRRet, senRelHumOut.y) annotation (Line(points={{
              -316.629,5.89091},{-316.629,-132},{27,-132}},
                                                   color={0,0,127}));
      connect(senTemSup.u, senTSup.T) annotation (Line(points={{-418,40},{-426,40},{
              -426,80},{394,80},{394,-73}}, color={0,0,127}));
    connect(fan.port_b, res.port_a) annotation (Line(points={{232,-85},{248,-85},
            {248,-74},{266,-74}}, color={0,127,255}));
    connect(res.port_b, volSenSup.port_a) annotation (Line(points={{286,-74},{320,
            -74},{320,-84},{346,-84}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-420,-260},
                {440,220}}),     graphics={
          Rectangle(
            extent={{-422,358},{598,-260}},
            lineColor={28,108,200},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-232,364},{368,10}},
            lineColor={28,108,200},
            fillColor={170,213,255},
            fillPattern=FillPattern.None,
            textString="CAV"),
          Rectangle(
            extent={{486,-258},{162,-106}},
            lineColor={28,108,200},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{38,-110},{588,-194}},
            lineColor={28,108,200},
            fillColor={175,175,175},
            fillPattern=FillPattern.None,
            textString="Power"),
          Text(
            extent={{66,-196},{596,-244}},
            lineColor={28,108,200},
            fillColor={175,175,175},
            fillPattern=FillPattern.None,
            textString="Fan  HC  CC")}),                             Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-420,-260},{440,220}})),
      uses(Buildings(version="8.0.0")),
        Documentation(revisions="<html>
<ul>
<li>November 19, 2020 by Thibault Marzullo:<br>First implementation.</li>
</ul>
</html>", info="<html>
<p>Packaged Single-Zone Rooftop Unit following the specifications of ASHRAE&apos;s HVAC System 3 (PZS-AC).</p>
</html>"));
    end ASHRAESystem3;
  Buildings.Utilities.Time.CalendarTime calTim(
      zerTim=Buildings.Utilities.Time.Types.ZeroTime.Custom,
      yearRef=2017,
      outputUnixTimeStamp=false)
                    "Calendar Time"
    annotation (Placement(transformation(extent={{-268,136},{-236,168}})));
  ASHRAESystem3 HVAC(mass_flow_nominal = 0.527, heaNomPow = 14035.23, CCNomPow = -8607.92, controls(fanOccSet = 0.4487, minOAHVACOff =  0.080548, minOAHVACOn = 0.1795)) "Core zone HVAC system"
    annotation (Placement(transformation(extent={{-98,-14},{-42,16}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{-206,152},{-186,172}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal1
    annotation (Placement(transformation(extent={{-206,130},{-186,150}})));
  Modelica.Blocks.Routing.Multiplex3 mul "Multiplex for gains"
    annotation (Placement(transformation(extent={{-30,84},{-10,104}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-82,84},{-62,104}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-82,124},{-62,144}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-82,52},{-62,72}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-202,58},{-162,98}}), iconTransformation(extent=
           {{-352,68},{-332,88}})));
Buildings.Utilities.IO.SignalExchange.Read senHeaPow(u(min=0.0, max=15000.0, unit="W"), description=
          "Core Heating Coil Power",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower)
      "\"Core heating coil power demand\""
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={120,-10})));
  ASHRAESystem3 HVAC1(mass_flow_nominal = 0.435, heaNomPow = 11316.80, CCNomPow = -6909.58, fan(per(pressure(V_flow={0.3702,0.3703}, dp={622.1,622}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0.3703}, eta={0.65}),
      motorEfficiency(V_flow={0.3703}, eta={0.825}))), controls(fanOccSet = 0.3703, minOAHVACOff =  0.061060, minOAHVACOn =  0.1649))   "Core zone HVAC system"
    annotation (Placement(transformation(extent={{-96,-94},{-40,-64}})));
  ASHRAESystem3 HVAC2(mass_flow_nominal = 0.423, heaNomPow = 9873.02, CCNomPow = -6137.71, fan(per(pressure(V_flow={0.3603,0.3604}, dp={622.1,622}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0.3604}, eta={0.65}),
      motorEfficiency(V_flow={0.3604}, eta={0.825}))), controls(fanOccSet = 0.3604, minOAHVACOff = 0.036222, minOAHVACOn =  0.1005))   "Core zone HVAC system"
    annotation (Placement(transformation(extent={{-96,-184},{-40,-154}})));
  ASHRAESystem3 HVAC3(mass_flow_nominal = 0.449, heaNomPow = 11587.62, CCNomPow = -7081.44, fan(per(pressure(V_flow={0.3823,0.3824}, dp={622.1,622}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0.3824}, eta={0.65}),
      motorEfficiency(V_flow={0.3824}, eta={0.825}))), controls(fanOccSet = 0.3824, minOAHVACOff = 0.061060, minOAHVACOn = 0.1597))   "Core zone HVAC system"
    annotation (Placement(transformation(extent={{-98,-272},{-42,-242}})));
  ASHRAESystem3 HVAC4(mass_flow_nominal = 0.414, heaNomPow = 9691.66, CCNomPow = -6779.76, fan(per(pressure(V_flow={0.3522,0.3523}, dp={622.1,622}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0.3523}, eta={0.65}),
      motorEfficiency(V_flow={0.3523}, eta={0.825}))), controls(fanOccSet = 0.3523, minOAHVACOff = 0.036222, minOAHVACOn = 0.1028))   "Core zone HVAC system"
    annotation (Placement(transformation(extent={{-96,-350},{-40,-320}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone perZon1(
      zoneName="Perimeter_ZN_1",
      redeclare final package Medium = Medium,
      nPorts=2) "Perimeter zone 1"
      annotation (Placement(transformation(extent={{54,-94},{94,-54}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone perZon2(
      zoneName="Perimeter_ZN_2",
      redeclare final package Medium = Medium,
      nPorts=2) "Perimeter zone 2"
      annotation (Placement(transformation(extent={{54,-184},{94,-144}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone perZon3(
      zoneName="Perimeter_ZN_3",
      redeclare final package Medium = Medium,
      nPorts=2) "Perimeter zone 3"
      annotation (Placement(transformation(extent={{52,-274},{92,-234}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone perZon4(
      zoneName="Perimeter_ZN_4",
      redeclare final package Medium = Medium,
      nPorts=2) "Perimeter zone 4"
      annotation (Placement(transformation(extent={{52,-352},{92,-312}})));
Buildings.Utilities.IO.SignalExchange.Read senHeaPow1(u(min=0.0, max=15000.0, unit="W"), description=
          "P1 Heating Coil Power", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower)
      "\"P1 heating coil power demand\""
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={166,-88})));
Buildings.Utilities.IO.SignalExchange.Read senHeaPow2(u(min=0.0, max=15000.0, unit="W"), description=
          "P2 Heating Coil Power", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower)
      "\"P2 heating coil power demand\""
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={136,-182})));
Buildings.Utilities.IO.SignalExchange.Read senHeaPow3(u(min=0.0, max=15000.0, unit="W"), description=
          "P3 Heating Coil Power", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower)
      "\"P3 heating coil power demand\""
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={164,-274})));
Buildings.Utilities.IO.SignalExchange.Read senHeaPow4(u(min=0.0, max=15000.0, unit="W"), description=
          "P4 Heating Coil Power", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower)
      "\"P4 heating coil power demand\""
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={132,-376})));
Buildings.Utilities.IO.SignalExchange.Read senHou(u(min=0.0, max=24, unit="1"), description=
          "Current hour - 24hr", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"Hour of the day - 24hr\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={146,-444})));
Buildings.Utilities.IO.SignalExchange.Read senDay(u(min=0.0, max=7, unit="1"), description=
          "Day of the week - 1 to 7", KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"Day of the week - 1 to 7\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={146,-476})));
Buildings.Utilities.IO.SignalExchange.Read senFanPow4(u(min=0.0, max=2000.0, unit="W"), description="P4 Fan Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P4 fan power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={132,-406})));
Buildings.Utilities.IO.SignalExchange.Read senCCPow4(u(min=-9000, max=0, unit="W"), description="P4 Cooling Coil Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P4 cooling coil power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={132,-346})));
Buildings.Utilities.IO.SignalExchange.Read senFanPow3(u(min=0.0, max=2000.0, unit="W"), description="P3 Fan Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P3 fan power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={164,-304})));
Buildings.Utilities.IO.SignalExchange.Read senCCPow3(u(min=-9000, max=0, unit="W"), description="P3 Cooling Coil Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P3 cooling coil power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={164,-244})));
Buildings.Utilities.IO.SignalExchange.Read senFanPow2(u(min=0.0, max=2000.0, unit="W"), description="P2 Fan Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P2 fan power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={136,-214})));
Buildings.Utilities.IO.SignalExchange.Read senCCPow2(u(min=-9000, max=0, unit="W"), description="P2 Cooling Coil Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P2 cooling coil power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={136,-154})));
Buildings.Utilities.IO.SignalExchange.Read senFanPow1(u(min=0.0, max=2000.0, unit="W"), description="P1 Fan Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P1 fan power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={166,-120})));
Buildings.Utilities.IO.SignalExchange.Read senCCPow1(u(min=-9000, max=0, unit="W"), description="P1 Cooling Coil Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"P1 cooling coil power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={166,-60})));
Buildings.Utilities.IO.SignalExchange.Read senFanPow(u(min=0.0, max=2000.0, unit="W"), description="Core Fan Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"Core zone fan power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={122,-40})));
Buildings.Utilities.IO.SignalExchange.Read senCCPow(u(min=-9000, max=0, unit="W"), description="Core Cooling Coil Power demand",
        KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "\"Core zone cooling coil power demand\"" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={122,20})));
Buildings.Utilities.IO.SignalExchange.Read senTemOA(u(min=240.0, max=320.0, unit="K"), description="OA Temperature",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "Outside air temperature from weather file" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={148,-508})));
Buildings.Utilities.IO.SignalExchange.Read senMin(
      u(min=0,
        max=60,
        unit="1"),
      description="Minutes",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "Minutes of the hour" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-154,186})));
    Modelica.Blocks.Math.MultiSum multiSum5(nu=3)
      annotation (Placement(transformation(extent={{220,-6},{232,6}})));
Buildings.Utilities.IO.SignalExchange.Read senPowCor(
      u(min=0.0,
        max=25000.0,
        unit="W"),
      description="Core AHU Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      "\"Core zone AHU power demand\"" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={264,0})));
    Modelica.Blocks.Math.MultiSum multiSum4(nu=3)
      annotation (Placement(transformation(extent={{242,-94},{254,-82}})));
Buildings.Utilities.IO.SignalExchange.Read senPowPer1(
      u(min=0.0,
        max=25000.0,
        unit="W"),
      description="Perimeter zone 1 AHU Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      "\"Perimeter zone 1 AHU power demand\"" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={294,-92})));
    Modelica.Blocks.Math.MultiSum multiSum3(nu=3)
      annotation (Placement(transformation(extent={{244,-188},{256,-176}})));
Buildings.Utilities.IO.SignalExchange.Read senPowPer2(
      u(min=0.0,
        max=25000.0,
        unit="W"),
      description="Perimeter zone 2 AHU Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      "\"Perimeter zone 2 AHU power demand\"" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={298,-184})));
    Modelica.Blocks.Math.MultiSum multiSum2(nu=3)
      annotation (Placement(transformation(extent={{240,-272},{252,-260}})));
Buildings.Utilities.IO.SignalExchange.Read senPowPer3(
      u(min=0.0,
        max=25000.0,
        unit="W"),
      description="Perimeter zone 3 AHU Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      "\"Perimeter zone 3 AHU power demand\"" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={302,-268})));
    Modelica.Blocks.Math.MultiSum multiSum(nu=3)
      annotation (Placement(transformation(extent={{230,-374},{242,-362}})));
Buildings.Utilities.IO.SignalExchange.Read senPowPer4(
      u(min=0.0,
        max=25000.0,
        unit="W"),
      description="Perimeter zone 4 AHU Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      "\"Perimeter zone 4 AHU power demand\"" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={312,-366})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-72,162},{-52,182}})));
  Modelica.Blocks.Sources.RealExpression minutes(y=60)
      annotation (Placement(transformation(extent={{-138,164},{-118,184}})));
Buildings.Utilities.IO.SignalExchange.Read senHouDec(
      u(min=0,
        max=24,
        unit="1"),
      description="Time",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
      "Minutes of the hour" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-30,172})));
equation

  connect(calTim.hour, integerToReal.u) annotation (Line(points={{-234.4,162.24},
          {-216.2,162.24},{-216.2,162},{-208,162}}, color={255,127,0}));
  connect(integerToReal.y, HVAC.hour) annotation (Line(points={{-185,162},{-130,
            162},{-130,-11.125},{-96.4372,-11.125}},    color={0,0,127}));
  connect(HVAC.day, integerToReal1.y) annotation (Line(points={{-96.4372,-6.5},{
            -134,-6.5},{-134,140},{-185,140}},color={0,0,127}));
  connect(HVAC.zonSupPort, corZon.ports[1]) annotation (Line(points={{-30.9302,
            20.375},{72.5349,20.375},{72.5349,64.9},{72,64.9}},
                                                              color={0,127,255}));
  connect(HVAC.zonRetPor, corZon.ports[2]) annotation (Line(points={{-30.8,
            4.125},{76.6,4.125},{76.6,64.9},{76,64.9}},
                                               color={0,127,255}));
  connect(HVAC.OAInlPor, Outside.ports[1]) annotation (Line(points={{-97.3488,
            20.375},{-144,20.375},{-144,11.6},{-184,11.6}},
                                                        color={0,127,255}));
  connect(HVAC.OAOutPor, Outside.ports[2]) annotation (Line(points={{-97.3488,4},
            {-140,4},{-140,10.8},{-184,10.8}},
                                           color={0,127,255}));
  connect(mul.u3[1],qLatGai_flow. y) annotation (Line(points={{-32,87},{-42,87},
            {-42,62},{-61,62}}, color={0,0,127}));
  connect(qConGai_flow.y,mul. u2[1]) annotation (Line(
      points={{-61,94},{-32,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qRadGai_flow.y,mul. u1[1]) annotation (Line(
      points={{-61,134},{-42,134},{-42,101},{-32,101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y, corZon.qGai_flow) annotation (Line(points={{-9,94},{52,94}},
                        color={0,0,127}));
  connect(Outside.weaBus, building.weaBus) annotation (Line(
      points={{-204,8.2},{-204,35.1},{-254,35.1},{-254,82}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, weaBus) annotation (Line(
      points={{-254,82},{-218,82},{-218,78},{-182,78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, HVAC.senTemOA) annotation (Line(
      points={{-182,78},{-140,78},{-140,-1},{-96.5674,-1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
    connect(corZon.TAir, HVAC.temSenRet) annotation (Line(points={{95,97.8},{
            31.5,97.8},{31.5,24.625},{-33.014,24.625}},
                                                   color={0,0,127}));
    connect(perZon1.qGai_flow, mul.y) annotation (Line(points={{52,-64},{52,-62},
            {46,-62},{46,94},{-9,94}}, color={0,0,127}));
    connect(perZon2.qGai_flow, mul.y) annotation (Line(points={{52,-154},{36,
            -154},{36,94},{-9,94}}, color={0,0,127}));
    connect(perZon3.qGai_flow, mul.y) annotation (Line(points={{50,-244},{22,
            -244},{22,94},{-9,94}}, color={0,0,127}));
    connect(perZon4.qGai_flow, mul.y) annotation (Line(points={{50,-322},{12,
            -322},{12,94},{-9,94}}, color={0,0,127}));
    connect(HVAC1.OAInlPor, Outside.ports[3]) annotation (Line(points={{
            -95.3488,-59.625},{-132,-59.625},{-132,-60},{-144,-60},{-144,8},{
            -184,8},{-184,10}}, color={0,127,255}));
    connect(HVAC1.OAOutPor, Outside.ports[4]) annotation (Line(points={{
            -95.3488,-76},{-100,-76},{-100,-74},{-146,-74},{-146,6},{-180,6},{
            -180,9.2},{-184,9.2}}, color={0,127,255}));
    connect(HVAC2.OAInlPor, Outside.ports[5]) annotation (Line(points={{
            -95.3488,-149.625},{-95.3488,-150},{-150,-150},{-150,8.4},{-184,8.4}},
          color={0,127,255}));
    connect(HVAC2.OAOutPor, Outside.ports[6]) annotation (Line(points={{
            -95.3488,-166},{-154,-166},{-154,7.6},{-184,7.6}}, color={0,127,255}));
    connect(HVAC3.OAInlPor, Outside.ports[7]) annotation (Line(points={{
            -97.3488,-237.625},{-160,-237.625},{-160,6.8},{-184,6.8}}, color={0,
            127,255}));
    connect(HVAC3.OAOutPor, Outside.ports[8]) annotation (Line(points={{
            -97.3488,-254},{-164,-254},{-164,6},{-184,6}}, color={0,127,255}));
    connect(HVAC4.OAInlPor, Outside.ports[9]) annotation (Line(points={{
            -95.3488,-315.625},{-168,-315.625},{-168,5.2},{-184,5.2}}, color={0,
            127,255}));
    connect(HVAC4.OAOutPor, Outside.ports[10]) annotation (Line(points={{
            -95.3488,-332},{-172,-332},{-172,4.4},{-184,4.4}}, color={0,127,255}));
    connect(HVAC4.zonSupPort, perZon4.ports[1]) annotation (Line(points={{
            -28.9302,-315.625},{10,-315.625},{10,-360},{70,-360},{70,-351.1}},
          color={0,127,255}));
    connect(HVAC4.zonRetPor, perZon4.ports[2]) annotation (Line(points={{-28.8,
            -331.875},{0,-331.875},{0,-366},{74,-366},{74,-351.1}}, color={0,
            127,255}));
    connect(HVAC3.zonSupPort, perZon3.ports[1]) annotation (Line(points={{
            -30.9302,-237.625},{8,-237.625},{8,-278},{70,-278},{70,-273.1}},
          color={0,127,255}));
    connect(HVAC3.zonRetPor, perZon3.ports[2]) annotation (Line(points={{-30.8,
            -253.875},{-30.8,-254},{2,-254},{2,-282},{74,-282},{74,-273.1}},
          color={0,127,255}));
    connect(HVAC2.zonSupPort, perZon2.ports[1]) annotation (Line(points={{
            -28.9302,-149.625},{2,-149.625},{2,-190},{72,-190},{72,-183.1}},
          color={0,127,255}));
    connect(HVAC2.zonRetPor, perZon2.ports[2]) annotation (Line(points={{-28.8,
            -165.875},{-2,-165.875},{-2,-198},{76,-198},{76,-183.1}}, color={0,
            127,255}));
    connect(HVAC1.zonSupPort, perZon1.ports[1]) annotation (Line(points={{
            -28.9302,-59.625},{6,-59.625},{6,-98},{72,-98},{72,-93.1}}, color={
            0,127,255}));
    connect(HVAC1.zonRetPor, perZon1.ports[2]) annotation (Line(points={{-28.8,
            -75.875},{0,-75.875},{0,-106},{76,-106},{76,-93.1}}, color={0,127,
            255}));
    connect(perZon1.TAir, HVAC1.temSenRet) annotation (Line(points={{95,-60.2},
            {100,-60.2},{100,-52},{-31.014,-52},{-31.014,-55.375}}, color={0,0,
            127}));
    connect(perZon2.TAir, HVAC2.temSenRet) annotation (Line(points={{95,-150.2},
            {102,-150.2},{102,-140},{-12,-140},{-12,-145.375},{-31.014,-145.375}},
          color={0,0,127}));
    connect(perZon3.TAir, HVAC3.temSenRet) annotation (Line(points={{93,-240.2},
            {102,-240.2},{102,-226},{-4,-226},{-4,-233.375},{-33.014,-233.375}},
          color={0,0,127}));
    connect(perZon4.TAir, HVAC4.temSenRet) annotation (Line(points={{93,-318.2},
            {102,-318.2},{102,-304},{2,-304},{2,-311.375},{-31.014,-311.375}},
          color={0,0,127}));
    connect(HVAC1.senTemOA, HVAC.senTemOA) annotation (Line(points={{-94.5674,
            -81},{-140,-81},{-140,-1},{-96.5674,-1}}, color={0,0,127}));
    connect(HVAC2.senTemOA, HVAC.senTemOA) annotation (Line(points={{-94.5674,
            -171},{-140,-171},{-140,-1},{-96.5674,-1}}, color={0,0,127}));
    connect(HVAC3.senTemOA, HVAC.senTemOA) annotation (Line(points={{-96.5674,
            -259},{-140,-259},{-140,-1},{-96.5674,-1}}, color={0,0,127}));
    connect(HVAC4.senTemOA, HVAC.senTemOA) annotation (Line(points={{-94.5674,
            -337},{-118,-337},{-118,-338},{-140,-338},{-140,-1},{-96.5674,-1}},
          color={0,0,127}));
    connect(HVAC1.day, integerToReal1.y) annotation (Line(points={{-94.4372,-86.5},
            {-134,-86.5},{-134,140},{-185,140}},        color={0,0,127}));
    connect(HVAC1.hour, HVAC.hour) annotation (Line(points={{-94.4372,-91.125},{
            -130,-91.125},{-130,-11.125},{-96.4372,-11.125}},  color={0,0,127}));
    connect(HVAC2.day, integerToReal1.y) annotation (Line(points={{-94.4372,-176.5},
            {-134,-176.5},{-134,140},{-185,140}},         color={0,0,127}));
    connect(HVAC2.hour, HVAC.hour) annotation (Line(points={{-94.4372,-181.125},
            {-130,-181.125},{-130,-11.125},{-96.4372,-11.125}}, color={0,0,127}));
    connect(HVAC3.day, integerToReal1.y) annotation (Line(points={{-96.4372,-264.5},
            {-134,-264.5},{-134,140},{-185,140}},         color={0,0,127}));
    connect(HVAC3.hour, HVAC.hour) annotation (Line(points={{-96.4372,-269.125},
            {-130,-269.125},{-130,-11.125},{-96.4372,-11.125}}, color={0,0,127}));
    connect(HVAC4.day, integerToReal1.y) annotation (Line(points={{-94.4372,
            -342.5},{-134,-342.5},{-134,140},{-185,140}}, color={0,0,127}));
    connect(HVAC4.hour, HVAC.hour) annotation (Line(points={{-94.4372,-347.125},
            {-94.4372,-348},{-130,-348},{-130,-11.125},{-96.4372,-11.125}},
          color={0,0,127}));
    connect(senHou.u, HVAC.hour) annotation (Line(points={{134,-444},{-130,-444},
            {-130,-11.125},{-96.4372,-11.125}},       color={0,0,127}));
    connect(senDay.u, integerToReal1.y) annotation (Line(points={{134,-476},{
            -134,-476},{-134,140},{-185,140}}, color={0,0,127}));
    connect(senHeaPow3.u, HVAC3.heaPowDem) annotation (Line(points={{152,-274},
            {142,-274},{142,-290},{-49.0326,-290},{-49.0326,-273.5}}, color={0,
            0,127}));
    connect(senFanPow3.u, HVAC3.fanPowDem) annotation (Line(points={{152,-304},
            {142,-304},{142,-294},{-55.2837,-294},{-55.2837,-273.5}},color={0,0,
            127}));
    connect(senCCPow3.u, HVAC3.cooPowDem) annotation (Line(points={{152,-244},{
            138,-244},{138,-284},{-42.1302,-284},{-42.1302,-273.5}},
                                                                 color={0,0,127}));
    connect(senHeaPow4.u, HVAC4.heaPowDem) annotation (Line(points={{120,-376},
            {110,-376},{110,-386},{-47.0326,-386},{-47.0326,-351.5}}, color={0,
            0,127}));
    connect(senCCPow4.u, HVAC4.cooPowDem) annotation (Line(points={{120,-346},{
            106,-346},{106,-380},{-40.1302,-380},{-40.1302,-351.5}},
                                                                 color={0,0,127}));
    connect(senFanPow4.u, HVAC4.fanPowDem) annotation (Line(points={{120,-406},
            {116,-406},{116,-390},{-53.2837,-390},{-53.2837,-351.5}},color={0,0,
            127}));
    connect(senCCPow2.u, HVAC2.cooPowDem) annotation (Line(points={{124,-154},{
            100,-154},{100,-204},{-40.1302,-204},{-40.1302,-185.5}},
                                                                 color={0,0,127}));
    connect(senHeaPow2.u, HVAC2.heaPowDem) annotation (Line(points={{124,-182},
            {104,-182},{104,-208},{-47.0326,-208},{-47.0326,-185.5}}, color={0,
            0,127}));
    connect(senFanPow2.u, HVAC2.fanPowDem) annotation (Line(points={{124,-214},
            {-53.2837,-214},{-53.2837,-185.5}},color={0,0,127}));
    connect(senCCPow1.u, HVAC1.cooPowDem) annotation (Line(points={{154,-60},{
            106,-60},{106,-112},{-40.1302,-112},{-40.1302,-95.5}},
                                                               color={0,0,127}));
    connect(senHeaPow1.u, HVAC1.heaPowDem) annotation (Line(points={{154,-88},{
            114,-88},{114,-118},{-47.0326,-118},{-47.0326,-95.5}}, color={0,0,
            127}));
    connect(senFanPow1.u, HVAC1.fanPowDem) annotation (Line(points={{154,-120},
            {122,-120},{122,-124},{-53.2837,-124},{-53.2837,-95.5}},color={0,0,127}));
    connect(senHeaPow.u, HVAC.heaPowDem) annotation (Line(points={{108,-10},{98,
            -10},{98,-24},{-49.0326,-24},{-49.0326,-15.5}},    color={0,0,127}));
    connect(senCCPow.u, HVAC.cooPowDem) annotation (Line(points={{110,20},{94,
            20},{94,-20},{-42.1302,-20},{-42.1302,-15.5}},
                                                       color={0,0,127}));
    connect(senFanPow.u, HVAC.fanPowDem) annotation (Line(points={{110,-40},{
            100,-40},{100,-28},{-55.2837,-28},{-55.2837,-15.5}},
                                                             color={0,0,127}));
  connect(senTemOA.u, HVAC.senTemOA) annotation (Line(points={{136,-508},{-140,
            -508},{-140,-1},{-96.5674,-1}},
                                    color={0,0,127}));
    connect(calTim.weekDay, integerToReal1.u) annotation (Line(points={{-234.4,
            145.6},{-221.2,145.6},{-221.2,140},{-208,140}}, color={255,127,0}));
    connect(senMin.u, calTim.minute) annotation (Line(points={{-166,186},{-220,186},
            {-220,166.4},{-234.4,166.4}}, color={0,0,127}));
    connect(multiSum5.y,senPowCor. u)
      annotation (Line(points={{233.02,0},{252,0}},   color={0,0,127}));
    connect(multiSum4.y,senPowPer1. u) annotation (Line(points={{255.02,-88},{268,
            -88},{268,-92},{282,-92}}, color={0,0,127}));
    connect(multiSum3.y,senPowPer2. u) annotation (Line(points={{257.02,-182},{272,
            -182},{272,-184},{286,-184}}, color={0,0,127}));
    connect(multiSum2.y,senPowPer3. u) annotation (Line(points={{253.02,-266},{270,
            -266},{270,-268},{290,-268}}, color={0,0,127}));
    connect(multiSum.y,senPowPer4. u) annotation (Line(points={{243.02,-368},{272,
            -368},{272,-366},{300,-366}}, color={0,0,127}));
    connect(senCCPow.y, multiSum5.u[1]) annotation (Line(points={{133,20},{176,20},
            {176,2.8},{220,2.8}}, color={0,0,127}));
    connect(senHeaPow.y, multiSum5.u[2]) annotation (Line(points={{131,-10},{176,
            -10},{176,4.44089e-16},{220,4.44089e-16}}, color={0,0,127}));
    connect(senFanPow.y, multiSum5.u[3]) annotation (Line(points={{133,-40},{180,
            -40},{180,-2.8},{220,-2.8}}, color={0,0,127}));
    connect(senCCPow1.y, multiSum4.u[1]) annotation (Line(points={{177,-60},{210,
            -60},{210,-85.2},{242,-85.2}}, color={0,0,127}));
    connect(senHeaPow1.y, multiSum4.u[2]) annotation (Line(points={{177,-88},{210,
            -88},{210,-88},{242,-88}}, color={0,0,127}));
    connect(senFanPow1.y, multiSum4.u[3]) annotation (Line(points={{177,-120},{210,
            -120},{210,-90.8},{242,-90.8}}, color={0,0,127}));
    connect(senCCPow2.y, multiSum3.u[1]) annotation (Line(points={{147,-154},{196,
            -154},{196,-179.2},{244,-179.2}}, color={0,0,127}));
    connect(senHeaPow2.y, multiSum3.u[2]) annotation (Line(points={{147,-182},{196,
            -182},{196,-182},{244,-182}}, color={0,0,127}));
    connect(senFanPow2.y, multiSum3.u[3]) annotation (Line(points={{147,-214},{196,
            -214},{196,-184.8},{244,-184.8}}, color={0,0,127}));
    connect(senCCPow3.y, multiSum2.u[1]) annotation (Line(points={{175,-244},{208,
            -244},{208,-263.2},{240,-263.2}}, color={0,0,127}));
    connect(senHeaPow3.y, multiSum2.u[2]) annotation (Line(points={{175,-274},{208,
            -274},{208,-266},{240,-266}}, color={0,0,127}));
    connect(senFanPow3.y, multiSum2.u[3]) annotation (Line(points={{175,-304},{212,
            -304},{212,-268.8},{240,-268.8}}, color={0,0,127}));
    connect(senCCPow4.y, multiSum.u[1]) annotation (Line(points={{143,-346},{186,
            -346},{186,-365.2},{230,-365.2}}, color={0,0,127}));
    connect(senHeaPow4.y, multiSum.u[2]) annotation (Line(points={{143,-376},{186,
            -376},{186,-368},{230,-368}}, color={0,0,127}));
    connect(senFanPow4.y, multiSum.u[3]) annotation (Line(points={{143,-406},{190,
            -406},{190,-370.8},{230,-370.8}}, color={0,0,127}));
    connect(senMin.y, div1.u1)
      annotation (Line(points={{-143,186},{-112,186}}, color={0,0,127}));
    connect(div1.y, add2.u1) annotation (Line(points={{-88,180},{-82,180},{-82,178},
            {-74,178}}, color={0,0,127}));
    connect(div1.u2, minutes.y)
      annotation (Line(points={{-112,174},{-117,174}}, color={0,0,127}));
    connect(add2.u2, HVAC.hour) annotation (Line(points={{-74,166},{-102,166},{-102,
            162},{-130,162},{-130,-11.125},{-96.4372,-11.125}}, color={0,0,127}));
    connect(add2.y, senHouDec.u)
      annotation (Line(points={{-50,172},{-42,172}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,
              -500},{180,200}})),                                Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-500},{180,
              200}})),
    uses(Buildings(version="8.0.0"), Modelica(version="3.2.3")),
    experiment(
      StopTime=84600,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SOM3;
  //SOM3 - A Spawn of EnergyPlus model for BOPTEST
  //Model: DOE Prototype Small Office Building
  //Zones:
  //        1: Core zone
  //        2: Perimeter 1
  //        3: Perimeter 2
  //        4: Perimeter 3
  //        5: Perimeter 4

  ////////////
  // INPUTS //
  ////////////

  // Experimental: zeroing

  Modelica.Blocks.Interfaces.RealInput oveZero_u(
    unit="1",
    min=0,
    max=1) "Core zone zeroing (experimental) (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveZero_activate
    "Activation for core zone zeroing";

  Modelica.Blocks.Interfaces.RealInput oveZero1_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 1 zeroing (experimental) (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveZero1_activate
    "Activation for core zone zeroing";

  Modelica.Blocks.Interfaces.RealInput oveZero2_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 2 zeroing (experimental) (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveZero2_activate
    "Activation for core zone zeroing";

  Modelica.Blocks.Interfaces.RealInput oveZero3_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 3 zeroing (experimental) (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveZero3_activate
    "Activation for core zone zeroing";

  Modelica.Blocks.Interfaces.RealInput oveZero4_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 4 zeroing (experimental) (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveZero4_activate
    "Activation for core zone zeroing";


  // Heating coils
  Modelica.Blocks.Interfaces.RealInput oveHCSet_u(
    unit="1",
    min=0,
    max=1) "Core zone heating coil setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet_activate
    "Activation for core zone heating coil setpoint";
  Modelica.Blocks.Interfaces.RealInput oveHCSet1_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 1 heating coil setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet1_activate
    "Activation for perimeter 1 heating coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet2_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 2 heating coil setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet2_activate
    "Activation for perimeter 2 heating coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet3_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 3 heating coil setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet3_activate
    "Activation for perimeter 3 heating coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet4_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 4 heating coil setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet4_activate
    "Activation for perimeter 4 heating coil setpoint";

  // Cooling coils

  Modelica.Blocks.Interfaces.RealInput oveCC_u(
    unit="1",
    min=0,
    max=1) "Core zone cooling coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC_activate
    "Activation for core zone cooling coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC1_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 1 cooling coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC1_activate
    "Activation for perimeter zone 1 cooling coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC2_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 2 cooling coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC2_activate
    "Activation for perimeter zone 2 cooling coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC3_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 3 cooling coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC3_activate
    "Activation for perimeter zone 3 cooling coil setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC4_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 4 cooling coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC4_activate
    "Activation for perimeter zone 4 cooling coil setpoint";

  // OA damper settings

  Modelica.Blocks.Interfaces.RealInput oveDSet_u(
    unit="1",
    min=0,
    max=1) "Core zone OA damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet_activate
    "Activation for core zone OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet1_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 1 OA damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet1_activate
    "Activation for perimeter zone 1 OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet2_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 2 OA damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet2_activate
    "Activation for perimeter zone 2 OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet3_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 3 OA damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet3_activate
    "Activation for perimeter zone 3 OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet4_u(
    unit="1",
    min=0,
    max=1) "Perimeter zone 4 OA damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet4_activate
    "Activation for perimeter zone 4 OA damper setpoint";

  // Fan On/Off signals

  Modelica.Blocks.Interfaces.RealInput oveVFRSet_u(
    unit="1",
    min=0,
    max=0.5) "Core zone fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet_activate
    "Activation for core zone fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet1_u(
    unit="1",
    min=0,
    max=0.5) "Perimeter zone 1 fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet1_activate
    "Activation for perimeter zone 1 fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet2_u(
    unit="1",
    min=0,
    max=0.5) "Perimeter zone 2 fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet2_activate
    "Activation for perimeter zone 2 fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet3_u(
    unit="1",
    min=0,
    max=0.5) "Perimeter zone 3 fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet3_activate
    "Activation for perimeter zone 3 fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet4_u(
    unit="1",
    min=0,
    max=0.5) "Perimeter zone 4 fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet4_activate
    "Activation for perimeter zone 4 fan VFR setpoint";

  // SETPOINTS //

  Modelica.Blocks.Interfaces.RealInput oveHeaSet_u(
    unit="K",
    min=0,
    max=310) "Core zone heating setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveHeaSet_activate
    "Core zone heating setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveCooSet_u(
    unit="K",
    min=0,
    max=310) "Core zone cooling setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveCooSet_activate
    "Core zone cooling setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveHeaSet1_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 1 heating setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveHeaSet1_activate
    "Perimeter zone 1 heating setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveCooSet1_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 1 cooling setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveCooSet1_activate
    "Perimeter zone 1 cooling setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveHeaSet2_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 2 heating setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveHeaSet2_activate
    "Perimeter zone 2 heating setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveCooSet2_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 2 cooling setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveCooSet2_activate
    "Perimeter zone 2 cooling setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveHeaSet3_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 3 heating setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveHeaSet3_activate
    "Perimeter zone 3 heating setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveCooSet3_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 3 cooling setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveCooSet3_activate
    "Perimeter zone 3 cooling setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveHeaSet4_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 4 heating setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveHeaSet4_activate
    "Perimeter zone 4 heating setpoint activate";

  Modelica.Blocks.Interfaces.RealInput oveCooSet4_u(
    unit="K",
    min=0,
    max=310) "Perimeter zone 4 cooling setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveCooSet4_activate
    "Perimeter zone 4 cooling setpoint activate";


  /////////////
  // OUTPUTS //
  /////////////

  Modelica.Blocks.Interfaces.RealOutput senTRoom_y(unit="K", min = 270, max = 310) = mod.HVAC.senTemRoo.y
    "Core Room Temperature";
  Modelica.Blocks.Interfaces.RealOutput senRH_y(unit="1", min = 0, max = 0.99) = mod.HVAC.senRelHumOut.y
    "Core Room HR";
  Modelica.Blocks.Interfaces.RealOutput senHeaPow_y(unit="W", min = 0, max = mod.HVAC.heaNomPow) = mod.senHeaPow.y
    "Core zone heating coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senCCPow_y(unit="W", min = mod.HVAC.CCNomPow, max = 0) = mod.senCCPow.y
    "Core zone cooling coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanPow_y(unit="W", min = 0, max = 2000) = mod.senFanPow.y
    "Core zone fan power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanVol_y(unit="m3/s", min = 0, max = 1) = mod.HVAC.senVolSup.y
    "Core zone fan volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senOAVol_y(unit="m3/s", min = 0, max = 1) = mod.HVAC.senVolOA.y
    "Core zone OA volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senPowCor_y(unit="W", min = 0, max = 25000) = mod.senPowCor.y
    "Core zone fAHU power demand";

  Modelica.Blocks.Interfaces.RealOutput senTRoom1_y(unit="K", min = 270, max = 310) = mod.HVAC1.senTemRoo.y
    "Perimeter zone 1 Temperature";
  Modelica.Blocks.Interfaces.RealOutput senRH1_y(unit="1", min = 0, max = 0.99) = mod.HVAC1.senRelHumOut.y
    "Perimeter zone 1 HR";
  Modelica.Blocks.Interfaces.RealOutput senHeaPow1_y(unit="1", min = 0, max = mod.HVAC1.heaNomPow) = mod.senHeaPow1.y
    "Perimeter zone 1 heating coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senCCPow1_y(unit="1", min = mod.HVAC1.CCNomPow, max = 0) = mod.senCCPow1.y
    "Perimeter zone 1 cooling coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanPow1_y(unit="1", min = 0, max = 2000) = mod.senFanPow1.y
    "Perimeter zone 1 fan power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanVol1_y(unit="m3/s", min = 0, max = 1) = mod.HVAC1.senVolSup.y
    "Perimeter zone 1 fan volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senOAVol1_y(unit="m3/s", min = 0, max = 1) = mod.HVAC1.senVolOA.y
    "Perimeter zone 1 OA volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senPowPer1_y(unit="W", min = 0, max = 25000) = mod.senPowPer1.y
    "Perimeter Zone 1 AHU power demand";

  Modelica.Blocks.Interfaces.RealOutput senTRoom2_y(unit="K", min = 270, max = 310) = mod.HVAC2.senTemRoo.y
    "Perimeter zone 2 Temperature";
  Modelica.Blocks.Interfaces.RealOutput senRH2_y(unit="1", min = 0, max = 0.99) = mod.HVAC2.senRelHumOut.y
    "Perimeter zone 2 HR";
  Modelica.Blocks.Interfaces.RealOutput senHeaPow2_y(unit="1", min = 0, max = mod.HVAC2.heaNomPow) = mod.senHeaPow2.y
    "Perimeter zone 2 heating coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senCCPow2_y(unit="1", min = mod.HVAC2.CCNomPow, max = 0) = mod.senCCPow2.y
    "Perimeter zone 2 cooling coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanPow2_y(unit="1", min = 0, max = 2000) = mod.senFanPow2.y
    "Perimeter zone 2 fan power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanVol2_y(unit="m3/s", min = 0, max = 1) = mod.HVAC2.senVolSup.y
    "Perimeter zone 2 fan volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senOAVol2_y(unit="m3/s", min = 0, max = 1) = mod.HVAC2.senVolOA.y
    "Perimeter zone 2 OA volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senPowPer2_y(unit="W", min = 0, max = 25000) = mod.senPowPer2.y
    "Perimeter Zone 2 AHU power demand";

  Modelica.Blocks.Interfaces.RealOutput senTRoom3_y(unit="K", min = 270, max = 310) = mod.HVAC3.senTemRoo.y
    "Perimeter zone 3 Temperature";
  Modelica.Blocks.Interfaces.RealOutput senRH3_y(unit="1", min = 0, max = 0.99) = mod.HVAC3.senRelHumOut.y
    "Perimeter zone 3 HR";
  Modelica.Blocks.Interfaces.RealOutput senHeaPow3_y(unit="1", min = 0, max = mod.HVAC3.heaNomPow) = mod.senHeaPow3.y
    "Perimeter zone 3 heating coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senCCPow3_y(unit="1", min = mod.HVAC3.CCNomPow, max = 0) = mod.senCCPow3.y
    "Perimeter zone 3 cooling coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanPow3_y(unit="1", min = 0, max = 2000) = mod.senFanPow3.y
    "Perimeter zone 3 fan power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanVol3_y(unit="m3/s", min = 0, max = 1) = mod.HVAC3.senVolSup.y
    "Perimeter zone 3 fan volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senOAVol3_y(unit="m3/s", min = 0, max = 1) = mod.HVAC3.senVolOA.y
    "Perimeter zone 3 OA volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senPowPer3_y(unit="W", min = 0, max = 25000) = mod.senPowPer3.y
    "Perimeter Zone 3 AHU power demand";

  Modelica.Blocks.Interfaces.RealOutput senTRoom4_y(unit="K", min = 270, max = 310) = mod.HVAC4.senTemRoo.y
    "Perimeter zone 4 Temperature";
  Modelica.Blocks.Interfaces.RealOutput senRH4_y(unit="1", min = 0, max = 0.99) = mod.HVAC4.senRelHumOut.y
    "Perimeter zone 4 HR";
  Modelica.Blocks.Interfaces.RealOutput senHeaPow4_y(unit="1", min = 0, max = mod.HVAC4.heaNomPow) = mod.senHeaPow4.y
    "Perimeter zone 4 heating coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senCCPow4_y(unit="1", min = mod.HVAC4.CCNomPow, max = 0) = mod.senCCPow4.y
    "Perimeter zone 4 cooling coil power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanPow4_y(unit="1", min = 0, max = 2000) = mod.senFanPow4.y
    "Perimeter zone 4 fan power demand";
  Modelica.Blocks.Interfaces.RealOutput senFanVol4_y(unit="m3/s", min = 0, max = 1) = mod.HVAC4.senVolSup.y
    "Perimeter zone 4 fan volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senOAVol4_y(unit="m3/s", min = 0, max = 1) = mod.HVAC4.senVolOA.y
    "Perimeter zone 4 OA volumetric flow rate";
  Modelica.Blocks.Interfaces.RealOutput senPowPer4_y(unit="W", min = 0, max = 25000) = mod.senPowPer4.y
    "Perimeter Zone 4 AHU power demand";

  Modelica.Blocks.Interfaces.RealOutput senMin_y(unit="1") = mod.senMin.y
    "Hour of the day (24hr format)";
  Modelica.Blocks.Interfaces.RealOutput senHou_y(unit="1") = mod.senHou.y
    "Hour of the day (24hr format)";
  Modelica.Blocks.Interfaces.RealOutput senHouDec_y(unit="1") = mod.senHouDec.y
    "Hour of the day (24hr, decimal format)";
  Modelica.Blocks.Interfaces.RealOutput senDay_y(unit="1") = mod.senDay.y
    "Day of the week (1-7)";
  Modelica.Blocks.Interfaces.RealOutput senTemOA_y(unit="K") = mod.senTemOA.y
    "Outside dry bulb air temperature";

  // Original model
  SOM3 mod(HVAC(
    oveHCSet(      uExt(y=oveHCSet_u), activate(y=oveHCSet_activate)),
    oveCCSet(      uExt(y=oveCC_u), activate(y=oveCC_activate)),
    oveDamSet(      uExt(y=oveDSet_u), activate(y=oveDSet_activate)),
    oveFanSet(      uExt(y=oveVFRSet_u), activate(y=oveVFRSet_activate)),
    controls(
      oveHeaSetpoint(      uExt(y=oveHeaSet_u), activate(y=oveHeaSet_activate)),
      oveCooSetpoint(      uExt(y=oveCooSet_u), activate(y=oveCooSet_activate)),
      oveZeroCommands(uExt(y=oveZero_u), activate(y=oveZero_activate)))),
    HVAC1(
    oveHCSet(      uExt(y=oveHCSet1_u), activate(y=oveHCSet1_activate)),
    oveCCSet(      uExt(y=oveCC1_u), activate(y=oveCC1_activate)),
    oveDamSet(      uExt(y=oveDSet1_u), activate(y=oveDSet1_activate)),
    oveFanSet(      uExt(y=oveVFRSet1_u), activate(y=oveVFRSet1_activate)),
    controls(
      oveHeaSetpoint(      uExt(y=oveHeaSet1_u), activate(y=oveHeaSet1_activate)),
      oveCooSetpoint(      uExt(y=oveCooSet1_u), activate(y=oveCooSet1_activate)),
      oveZeroCommands(uExt(y=oveZero1_u), activate(y=oveZero1_activate)))),
    HVAC2(
    oveHCSet(      uExt(y=oveHCSet2_u), activate(y=oveHCSet2_activate)),
    oveCCSet(      uExt(y=oveCC2_u), activate(y=oveCC2_activate)),
    oveDamSet(      uExt(y=oveDSet2_u), activate(y=oveDSet2_activate)),
    oveFanSet(      uExt(y=oveVFRSet2_u), activate(y=oveVFRSet2_activate)),
    controls(
      oveHeaSetpoint(      uExt(y=oveHeaSet2_u), activate(y=oveHeaSet2_activate)),
      oveCooSetpoint(      uExt(y=oveCooSet2_u), activate(y=oveCooSet2_activate)),
      oveZeroCommands(uExt(y=oveZero2_u), activate(y=oveZero2_activate)))),
    HVAC3(
    oveHCSet(      uExt(y=oveHCSet3_u), activate(y=oveHCSet3_activate)),
    oveCCSet(      uExt(y=oveCC3_u), activate(y=oveCC3_activate)),
    oveDamSet(      uExt(y=oveDSet3_u), activate(y=oveDSet3_activate)),
    oveFanSet(      uExt(y=oveVFRSet3_u), activate(y=oveVFRSet3_activate)),
    controls(
      oveHeaSetpoint(      uExt(y=oveHeaSet3_u), activate(y=oveHeaSet3_activate)),
      oveCooSetpoint(      uExt(y=oveCooSet3_u), activate(y=oveCooSet3_activate)),
      oveZeroCommands(uExt(y=oveZero3_u), activate(y=oveZero3_activate)))),
    HVAC4(
    oveHCSet(      uExt(y=oveHCSet4_u), activate(y=oveHCSet4_activate)),
    oveCCSet(      uExt(y=oveCC4_u), activate(y=oveCC4_activate)),
    oveDamSet(      uExt(y=oveDSet4_u), activate(y=oveDSet4_activate)),
    oveFanSet(      uExt(y=oveVFRSet4_u), activate(y=oveVFRSet4_activate)),
    controls(
      oveHeaSetpoint(      uExt(y=oveHeaSet4_u), activate(y=oveHeaSet4_activate)),
      oveCooSetpoint(      uExt(y=oveCooSet4_u), activate(y=oveCooSet4_activate)),
      oveZeroCommands(uExt(y=oveZero4_u), activate(y=oveZero4_activate)))))
    "Original model with overwrites";

  annotation (uses(Modelica(version="3.2.3"), Buildings(version="8.0.0")),
      experiment(
      StartTime=13477400,
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end wrapped;
