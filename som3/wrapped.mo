within som3;
model wrapped "Wrapped model"
  model SOM3 "Spawn of Energy+ for BOPTEST"

    model CAVControlv2 "simple controller"

      parameter Modelica.SIunits.VolumeFlowRate minOA;
      parameter Modelica.SIunits.VolumeFlowRate designVFR;
      Modelica.Blocks.Interfaces.BooleanInput isDay annotation (Placement(
            transformation(extent={{-406,208},{-366,248}}), iconTransformation(
              extent={{-414,28},{-374,68}})));
      Modelica.Blocks.Interfaces.BooleanInput isNight annotation (Placement(
            transformation(extent={{-406,138},{-366,178}}), iconTransformation(
              extent={{-414,-42},{-374,-2}})));
      Modelica.Blocks.Interfaces.BooleanInput isSunday annotation (Placement(
            transformation(extent={{-406,54},{-366,94}}), iconTransformation(
              extent={{-414,-126},{-374,-86}})));
      Modelica.Blocks.Interfaces.RealInput T_return annotation (Placement(
            transformation(extent={{-406,12},{-366,52}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-370,-314})));
      Modelica.Blocks.Interfaces.RealInput HR_return annotation (Placement(
            transformation(extent={{-406,-22},{-366,18}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-300,-310})));
      Modelica.Blocks.Interfaces.RealOutput HC_Setpoint annotation (Placement(
            transformation(extent={{390,210},{426,246}}), iconTransformation(
            extent={{-18,-18},{18,18}},
            rotation=270,
            origin={74,-312})));
      Modelica.Blocks.Interfaces.BooleanOutput CC_OnOff annotation (Placement(
            transformation(extent={{390,260},{432,302}}), iconTransformation(
            extent={{-21,-21},{21,21}},
            rotation=270,
            origin={7,-313})));
      Modelica.Blocks.Interfaces.RealOutput Damper_Setting annotation (
          Placement(transformation(extent={{392,170},{430,208}}),
            iconTransformation(
            extent={{-19,-19},{19,19}},
            rotation=270,
            origin={131,-311})));
      Modelica.Blocks.Interfaces.RealInput T_OA annotation (Placement(
            transformation(extent={{-406,-58},{-366,-18}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-236,-312})));
      Buildings.Controls.OBC.CDL.Logical.Switch HeaSupTemp
        annotation (Placement(transformation(extent={{118,-208},{138,-188}})));
      Modelica.Blocks.Interfaces.RealInput T_mixed annotation (Placement(
            transformation(extent={{-406,-94},{-366,-54}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-168,-312})));
      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCooOccupied(uLow=296.15,
          uHigh=297.15)
        annotation (Placement(transformation(extent={{-10,34},{10,54}})));
      Buildings.Controls.OBC.CDL.Logical.Timer tim
        annotation (Placement(transformation(extent={{86,38},{106,58}})));
      Modelica.Blocks.Logical.And CyclingDelayPassed
        annotation (Placement(transformation(extent={{214,-28},{234,-8}})));
      Buildings.Controls.OBC.CDL.Logical.Not not2
        annotation (Placement(transformation(extent={{48,34},{68,54}})));
      Modelica.Blocks.Logical.GreaterEqual EnoughTimeSinceLastStop
        annotation (Placement(transformation(extent={{136,36},{156,56}})));
      Modelica.Blocks.Sources.Constant StartStopDelay(k=600)
        annotation (Placement(transformation(extent={{82,0},{102,20}})));
      Buildings.Controls.OBC.CDL.Logical.Latch lat
        annotation (Placement(transformation(extent={{176,24},{196,44}})));
      Modelica.Blocks.Logical.FallingEdge fallingEdge
        annotation (Placement(transformation(extent={{130,-18},{150,2}})));
      Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
        annotation (Placement(transformation(extent={{258,-56},{278,-36}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
        annotation (Placement(transformation(extent={{138,-94},{158,-74}})));
      Modelica.Blocks.Interaction.Show.RealValue realValue
        annotation (Placement(transformation(extent={{-310,-6},{-290,14}})));
      Modelica.Blocks.Interaction.Show.BooleanValue booleanValue
        annotation (Placement(transformation(extent={{-310,84},{-290,104}})));
      Modelica.Blocks.Interaction.Show.RealValue realValue1
        annotation (Placement(transformation(extent={{-308,-46},{-288,-26}})));
      Modelica.Blocks.Logical.And CyclingDelayPassed1
        annotation (Placement(transformation(extent={{-260,68},{-240,88}})));
      Buildings.Controls.OBC.CDL.Logical.Not not4
        annotation (Placement(transformation(extent={{-302,58},{-282,78}})));
      Buildings.Utilities.IO.BCVTB.From_degC froDegC annotation (Placement(
            transformation(extent={{-270,-152},{-250,-132}})));
      Modelica.Blocks.Sources.Constant cooSetUno(k=26.7) annotation (Placement(
            transformation(extent={{-354,-168},{-334,-148}})));
      Modelica.Blocks.Sources.Constant cooSetOcc(k=24) annotation (Placement(
            transformation(extent={{-354,-136},{-334,-116}})));
      Modelica.Blocks.Sources.Constant heaSetUno(k=15.6) annotation (Placement(
            transformation(extent={{-354,-248},{-334,-228}})));
      Modelica.Blocks.Sources.Constant heaSetOcc(k=21) annotation (Placement(
            transformation(extent={{-354,-214},{-334,-194}})));
      Buildings.Controls.OBC.CDL.Logical.Switch heaSet annotation (Placement(
            transformation(extent={{-298,-230},{-278,-210}})));
      Buildings.Controls.OBC.CDL.Logical.Switch cooSet annotation (Placement(
            transformation(extent={{-300,-152},{-280,-132}})));
      Buildings.Utilities.IO.BCVTB.From_degC froDegC1 annotation (Placement(
            transformation(extent={{-192,-230},{-172,-210}})));
      Modelica.Blocks.Sources.Constant heaOff(k=0)
        annotation (Placement(transformation(extent={{22,-242},{42,-222}})));
      Modelica.Blocks.Interfaces.RealInput T_supp annotation (Placement(
            transformation(extent={{-404,-132},{-364,-92}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-108,-312})));
      Modelica.Blocks.Sources.Constant VFR(k=designVFR)
        annotation (Placement(transformation(extent={{196,118},{216,138}})));
      Modelica.Blocks.Interfaces.RealOutput VFR_setting annotation (Placement(
            transformation(extent={{242,-322},{262,-302}}), iconTransformation(
            extent={{-17,-17},{17,17}},
            rotation=270,
            origin={201,-309})));
      Buildings.Controls.OBC.CDL.Logical.Switch supSet1
        annotation (Placement(transformation(extent={{236,92},{256,112}})));
      Modelica.Blocks.Sources.Constant VFR1(k=0.01)
        annotation (Placement(transformation(extent={{196,78},{216,98}})));
      Buildings.Controls.Continuous.LimPID conPID1(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        k=0.5,
        Ti=200)
        annotation (Placement(transformation(extent={{18,-144},{38,-124}})));
      Modelica.Blocks.Interaction.Show.RealValue realValue2
        annotation (Placement(transformation(extent={{-272,-74},{-252,-54}})));
      Modelica.Blocks.Interaction.Show.RealValue realValue3 annotation (
          Placement(transformation(extent={{-210,-166},{-190,-146}})));
      Buildings.Controls.OBC.CDL.Logical.Switch supSet2
        annotation (Placement(transformation(extent={{238,186},{258,206}})));
      Modelica.Blocks.Interfaces.RealInput OA_VFR annotation (Placement(
            transformation(extent={{-146,158},{-106,198}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-52,-312})));
      Buildings.Controls.Continuous.LimPID conPID2(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        k=0.1,
        Ti=100)
        annotation (Placement(transformation(extent={{56,214},{76,234}})));
      Modelica.Blocks.Sources.Constant VFR2(k=minOA)
        annotation (Placement(transformation(extent={{2,214},{22,234}})));
      Modelica.Blocks.Sources.Constant VFR3(k=0)
        annotation (Placement(transformation(extent={{132,174},{152,194}})));
      Modelica.Blocks.Logical.GreaterEqual EnoughTimeSinceLastStop1
        annotation (Placement(transformation(extent={{160,-152},{180,-132}})));
      Modelica.Blocks.Sources.Constant StartStopDelay1(k=0)
        annotation (Placement(transformation(extent={{110,-158},{130,-138}})));
    equation
      connect(EnoughTimeSinceLastStop.u1, tim.y) annotation (Line(points={{134,46},
              {118,46},{118,48},{108,48}}, color={0,0,127}));
      connect(StartStopDelay.y, EnoughTimeSinceLastStop.u2) annotation (Line(
            points={{103,10},{116,10},{116,38},{134,38}}, color={0,0,127}));
      connect(not2.y, tim.u) annotation (Line(points={{70,44},{76,44},{76,48},{84,
              48}}, color={255,0,255}));

      connect(CyclingDelayPassed.u2, not2.u) annotation (Line(points={{212,-26},
              {38,-26},{38,44},{46,44}}, color={255,0,255}));
      connect(EnoughTimeSinceLastStop.y, lat.u) annotation (Line(points={{157,46},
              {160,46},{160,34},{174,34}}, color={255,0,255}));
      connect(lat.y, CyclingDelayPassed.u1) annotation (Line(points={{198,34},{202,
              34},{202,-18},{212,-18}}, color={255,0,255}));
      connect(fallingEdge.u, not2.u) annotation (Line(points={{128,-8},{38,-8},{
              38,44},{46,44}}, color={255,0,255}));
      connect(hysCooOccupied.y, not2.u)
        annotation (Line(points={{12,44},{46,44}}, color={255,0,255}));
      connect(logicalSwitch.u1, CyclingDelayPassed.y) annotation (Line(points={{
              256,-38},{246,-38},{246,-18},{235,-18}}, color={255,0,255}));
      connect(logicalSwitch.y, CC_OnOff) annotation (Line(points={{279,-46},{279,
              281},{411,281}}, color={255,0,255}));
      connect(booleanConstant.y, logicalSwitch.u3) annotation (Line(points={{159,
              -84},{208,-84},{208,-54},{256,-54}}, color={255,0,255}));
      connect(booleanValue.activePort, isNight) annotation (Line(points={{-311.5,
              94},{-340,94},{-340,158},{-386,158}}, color={255,0,255}));
      connect(realValue.numberPort, HR_return) annotation (Line(points={{-311.5,
              4},{-348,4},{-348,-2},{-386,-2}}, color={0,0,127}));
      connect(T_OA, realValue1.numberPort) annotation (Line(points={{-386,-38},{
              -348,-38},{-348,-36},{-309.5,-36}}, color={0,0,127}));
      connect(isSunday, not4.u) annotation (Line(points={{-386,74},{-344,74},{-344,
              68},{-304,68}}, color={255,0,255}));
      connect(not4.y, CyclingDelayPassed1.u2) annotation (Line(points={{-280,68},
              {-272,68},{-272,70},{-262,70}}, color={255,0,255}));
      connect(CyclingDelayPassed1.u1, isDay) annotation (Line(points={{-262,78},
              {-268,78},{-268,120},{-318,120},{-318,228},{-386,228}}, color={255,
              0,255}));
      connect(CyclingDelayPassed1.y, logicalSwitch.u2) annotation (Line(points={
              {-239,78},{8,78},{8,-46},{256,-46}}, color={255,0,255}));
      connect(cooSetOcc.y, cooSet.u1) annotation (Line(points={{-333,-126},{-312,
              -126},{-312,-134},{-302,-134}}, color={0,0,127}));
      connect(cooSetUno.y, cooSet.u3) annotation (Line(points={{-333,-158},{-312,
              -158},{-312,-150},{-302,-150}}, color={0,0,127}));
      connect(heaSetOcc.y, heaSet.u1) annotation (Line(points={{-333,-204},{-312,
              -204},{-312,-212},{-300,-212}}, color={0,0,127}));
      connect(heaSetUno.y, heaSet.u3) annotation (Line(points={{-333,-238},{-312,
              -238},{-312,-228},{-300,-228}}, color={0,0,127}));
      connect(cooSet.u2, CyclingDelayPassed1.y) annotation (Line(points={{-302,-142},
              {-306,-142},{-306,-94},{-239,-94},{-239,78}}, color={255,0,255}));
      connect(cooSet.y, froDegC.Celsius) annotation (Line(points={{-278,-142},{-274,
              -142},{-274,-142.4},{-272,-142.4}}, color={0,0,127}));
      connect(heaSet.y, froDegC1.Celsius) annotation (Line(points={{-276,-220},{
              -272,-220},{-272,-220.4},{-194,-220.4}}, color={0,0,127}));
      connect(HeaSupTemp.y, HC_Setpoint) annotation (Line(points={{140,-198},{236,
              -198},{236,-94},{334,-94},{334,228},{408,228}}, color={0,0,127}));
      connect(heaSet.u2, cooSet.u2) annotation (Line(points={{-300,-220},{-304,-220},
              {-304,-142},{-302,-142}}, color={255,0,255}));
      connect(VFR.y, supSet1.u1) annotation (Line(points={{217,128},{226,128},{226,
              110},{234,110}}, color={0,0,127}));
      connect(VFR1.y, supSet1.u3) annotation (Line(points={{217,88},{226,88},{226,
              94},{234,94}}, color={0,0,127}));
      connect(supSet1.y, VFR_setting) annotation (Line(points={{258,102},{330,102},
              {330,-312},{252,-312}}, color={0,0,127}));
      connect(conPID1.y, HeaSupTemp.u1) annotation (Line(points={{39,-134},{78,-134},
              {78,-190},{116,-190}}, color={0,0,127}));
      connect(HeaSupTemp.u2, logicalSwitch.u2) annotation (Line(points={{116,-198},
              {48,-198},{48,-176},{-34,-176},{-34,-46},{256,-46}}, color={255,0,
              255}));
      connect(conPID1.u_s, froDegC1.Kelvin) annotation (Line(points={{16,-134},{
              -66,-134},{-66,-220},{-148,-220},{-148,-220.2},{-171,-220.2}},
            color={0,0,127}));
      connect(conPID1.u_m, T_return) annotation (Line(points={{28,-146},{-102,-146},
              {-102,6},{-220,6},{-220,32},{-386,32}}, color={0,0,127}));
      connect(T_supp, realValue2.numberPort) annotation (Line(points={{-384,-112},
              {-328,-112},{-328,-64},{-273.5,-64}}, color={0,0,127}));
      connect(realValue3.numberPort, froDegC.Kelvin) annotation (Line(points={{-211.5,
              -156},{-230,-156},{-230,-142.2},{-249,-142.2}}, color={0,0,127}));
      connect(hysCooOccupied.u, T_return) annotation (Line(points={{-12,44},{-118,
              44},{-118,32},{-386,32}}, color={0,0,127}));
      connect(supSet2.y, Damper_Setting) annotation (Line(points={{260,196},{330,
              196},{330,189},{411,189}}, color={0,0,127}));
      connect(OA_VFR, conPID2.u_m) annotation (Line(points={{-126,178},{64,178},
              {64,212},{66,212}}, color={0,0,127}));
      connect(conPID2.y, supSet2.u1) annotation (Line(points={{77,224},{158,224},
              {158,204},{236,204}}, color={0,0,127}));
      connect(VFR2.y, conPID2.u_s)
        annotation (Line(points={{23,224},{54,224}}, color={0,0,127}));
      connect(VFR3.y, supSet2.u3) annotation (Line(points={{153,184},{196,184},{
              196,188},{236,188}}, color={0,0,127}));
      connect(HeaSupTemp.u3, HeaSupTemp.u1) annotation (Line(points={{116,-206},
              {104,-206},{104,-190},{116,-190}}, color={0,0,127}));
      connect(StartStopDelay1.y, EnoughTimeSinceLastStop1.u2) annotation (Line(
            points={{131,-148},{144,-148},{144,-150},{158,-150}}, color={0,0,127}));
      connect(EnoughTimeSinceLastStop1.u1, HC_Setpoint) annotation (Line(points=
             {{158,-142},{154,-142},{154,-198},{236,-198},{236,-94},{334,-94},{334,
              228},{408,228}}, color={0,0,127}));
      connect(EnoughTimeSinceLastStop1.y, supSet1.u2) annotation (Line(points={{
              181,-142},{196,-142},{196,102},{234,102}}, color={255,0,255}));
      connect(supSet2.u2, logicalSwitch.u2) annotation (Line(points={{236,196},{
              122,196},{122,78},{8,78},{8,-46},{256,-46}}, color={255,0,255}));
      connect(fallingEdge.y, lat.clr) annotation (Line(points={{151,-8},{164,-8},
              {164,28},{174,28}}, color={255,0,255}));
      annotation (Diagram(coordinateSystem(extent={{-360,-280},{240,80}})),
          Icon(coordinateSystem(extent={{-360,-280},{240,80}})));
    end CAVControlv2;

    model System3CAV "ASHRAE System 3 CAV system"
      parameter Modelica.SIunits.Power heaNomPow;

      replaceable package Medium = Buildings.Media.Air
        "Buildings library air media package";
      Buildings.Fluid.Actuators.Dampers.MixingBox MixingDamper(
        redeclare package Medium = Medium,
        from_dp=true,
        allowFlowReversal=false,
        mOut_flow_nominal=0.5,
        mRec_flow_nominal=0.5,
        mExh_flow_nominal=0.5,
        dpDamExh_nominal=100,
        dpDamOut_nominal=100,
        dpDamRec_nominal=100) "Economizer: mixing box with damper"
        annotation (Placement(transformation(extent={{-264,-26},{-202,36}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort T_OA_DB(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{-340,116},{-320,136}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort T_Mixed(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{-174,14},{-154,34}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort T_Return(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=294.15)
        annotation (Placement(transformation(extent={{246,-146},{266,-126}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort T_Supply(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{232,14},{252,34}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_outside_inlet(redeclare
          package Medium = Medium) annotation (Placement(transformation(extent={
                {-424,108},{-404,128}}), iconTransformation(extent={{-424,108},{
                -404,128}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_return(redeclare package
          Medium = Medium) annotation (Placement(transformation(extent={{426,18},
                {446,38}}), iconTransformation(extent={{426,18},{446,38}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_outside_outlet(redeclare
          package Medium = Medium) annotation (Placement(transformation(extent={
                {-424,14},{-404,34}}), iconTransformation(extent={{-424,14},{-404,
                34}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_supply(redeclare package
          Medium = Medium) annotation (Placement(transformation(extent={{424,110},
                {444,130}}), iconTransformation(extent={{424,110},{444,130}})));
      Modelica.Blocks.Interfaces.RealInput OA_Damper_mixing_command annotation (
         Placement(transformation(extent={{-448,360},{-408,400}}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={244,444})));
      Modelica.Blocks.Interfaces.RealInput T_HeatingCoil_Command annotation (
          Placement(transformation(extent={{226,432},{266,472}}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={170,444})));
      Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed sinSpeDX(
        redeclare package Medium = Medium,
        datCoi(
          nSta=1,
          minSpeRat=0.2,
          sta={
              Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
                  spe=1800/60,
                  nomVal=
                Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
                    Q_flow_nominal=-8586.56,
                    COP_nominal=3.67,
                    SHR_nominal=0.79,
                    m_flow_nominal=0.53,
                    TEvaIn_nominal=273.15 + 17.74,
                    TConIn_nominal=308.15,
                    phiIn_nominal=0.48,
                    tWet=600),
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
        m_flow_small=1E-4*abs(0.5),
        from_dp=false,
        dp_nominal=0,
        T_start=288.65)
        annotation (Placement(transformation(extent={{-86,-4},{-28,54}})));

      Buildings.Fluid.Sensors.TemperatureTwoPort debug_T_CoolingCoil(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{4,14},{24,34}})));
      Buildings.Fluid.Movers.FlowControlled_m_flow fan(
        redeclare package Medium = Medium,
        T_start=288.65,
        allowFlowReversal=true,
        m_flow_nominal=0.45,
        redeclare parameter Buildings.Fluid.Movers.Data.Generic per(
          pressure(V_flow={0.439,0.44}, dp={623,622}),
          use_powerCharacteristic=false,
          hydraulicEfficiency(V_flow={0.44}, eta={0.65}),
          motorEfficiency(V_flow={0.44}, eta={0.825})),
        dp_nominal=622)
        annotation (Placement(transformation(extent={{160,2},{204,46}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort debug_T_HeatingCoil(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{122,14},{142,34}})));
      Modelica.Blocks.Interfaces.RealOutput HVAC_Power_demand annotation (
          Placement(transformation(extent={{434,280},{478,324}}),
            iconTransformation(extent={{436,188},{480,232}})));
      Modelica.Blocks.Routing.Multiplex3 multiplex3_HVAC_Power(
        n1=1,
        n2=1,
        n3=1)
        annotation (Placement(transformation(extent={{238,292},{258,312}})));
      Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        T_start=288.65)
        annotation (Placement(transformation(extent={{280,14},{300,34}})));
      Modelica.Blocks.Interfaces.RealInput Fan_Flowrate_setpoint annotation (
          Placement(transformation(extent={{342,490},{382,530}}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={358,444})));
      FanControl fanControl
        annotation (Placement(transformation(extent={{172,82},{192,102}})));
      Modelica.Blocks.Interfaces.BooleanInput CoolingCoil_OnOff_Command
        annotation (Placement(transformation(extent={{166,442},{206,482}}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={84,442})));
      Modelica.Blocks.Interfaces.RealOutput HVAC_Temperature_sensors
        annotation (Placement(transformation(extent={{436,228},{480,272}}),
            iconTransformation(extent={{434,252},{478,296}})));
      Modelica.Blocks.Routing.Multiplex4 multiplex4_Temperatures
        annotation (Placement(transformation(extent={{240,232},{260,252}})));
      Modelica.Blocks.Interfaces.RealOutput debug_T_CC annotation (Placement(
            transformation(extent={{424,372},{468,416}}), iconTransformation(
              extent={{434,306},{478,350}})));
      Modelica.Blocks.Interfaces.RealOutput debug_T_HC annotation (Placement(
            transformation(extent={{428,334},{472,378}}), iconTransformation(
              extent={{436,362},{480,406}})));
      Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(redeclare package
          Medium = Medium, m_flow_nominal=0.5) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={198,-136})));
      Modelica.Blocks.Interfaces.RealOutput TR annotation (Placement(
            transformation(extent={{436,180},{480,224}}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={-340,440})));
      Modelica.Blocks.Interfaces.RealOutput TOA annotation (Placement(
            transformation(extent={{436,142},{480,186}}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={-194,440})));
      Modelica.Blocks.Interfaces.RealOutput HR annotation (Placement(
            transformation(extent={{440,60},{484,104}}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={-274,444})));
      Modelica.Blocks.Math.Add3 add3_1
        annotation (Placement(transformation(extent={{238,326},{258,346}})));
      Modelica.Blocks.Interfaces.RealOutput HVAC_Tot_H_Power annotation (
          Placement(transformation(extent={{438,-46},{482,-2}}),
            iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=0,
            origin={456,442})));
      Modelica.Blocks.Interfaces.RealInput T_OutsideAir annotation (Placement(
            transformation(extent={{-442,158},{-402,198}}), iconTransformation(
              extent={{-448,362},{-408,402}})));
      Modelica.Blocks.Interfaces.RealOutput TM annotation (Placement(
            transformation(extent={{-128,-84},{-84,-40}}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={-126,442})));
      Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
        redeclare package Medium = Medium,
        allowFlowReversal=true,
        m_flow_nominal=0.5,
        dp_nominal=10,
        T_start=288.65,
        Q_flow_nominal=heaNomPow)
        annotation (Placement(transformation(extent={{60,4},{98,46}})));
      Modelica.Blocks.Interfaces.RealOutput TS annotation (Placement(
            transformation(
            extent={{-22,-22},{22,22}},
            rotation=270,
            origin={-160,-108}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={-46,444})));
      Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo1(redeclare package
          Medium = Medium, m_flow_nominal=0.5)
        annotation (Placement(transformation(extent={{-300,116},{-280,136}})));
      Modelica.Blocks.Interfaces.RealOutput OA_VFR annotation (Placement(
            transformation(extent={{426,426},{470,470}}), iconTransformation(
            extent={{-22,-22},{22,22}},
            rotation=90,
            origin={18,444})));
      Modelica.Blocks.Interaction.Show.RealValue realValue
        annotation (Placement(transformation(extent={{-202,70},{-182,90}})));
    equation
      connect(port_outside_inlet, port_outside_inlet) annotation (Line(points={{
              -414,118},{-412,118},{-412,110},{-410,110},{-410,118},{-414,118}},
            color={0,127,255}));
      connect(port_outside_outlet, MixingDamper.port_Exh) annotation (Line(
            points={{-414,24},{-334,24},{-334,-13.6},{-264,-13.6}}, color={0,127,
              255}));
      connect(T_Mixed.port_a, MixingDamper.port_Sup) annotation (Line(points={{-174,
              24},{-180,24},{-180,23.6},{-202,23.6}}, color={0,127,255}));
      connect(T_Mixed.port_b, sinSpeDX.port_a) annotation (Line(points={{-154,24},
              {-120,24},{-120,25},{-86,25}}, color={0,127,255}));
      connect(sinSpeDX.port_b, debug_T_CoolingCoil.port_a) annotation (Line(
            points={{-28,25},{-12,25},{-12,24},{4,24}}, color={0,127,255}));
      connect(debug_T_HeatingCoil.port_b, fan.port_a)
        annotation (Line(points={{142,24},{160,24}}, color={0,127,255}));
      connect(fan.port_b, T_Supply.port_a)
        annotation (Line(points={{204,24},{232,24}}, color={0,127,255}));
      connect(port_return, T_Return.port_b) annotation (Line(points={{436,28},{350,
              28},{350,-136},{266,-136}}, color={0,127,255}));
      connect(sinSpeDX.P, multiplex3_HVAC_Power.u1[1]) annotation (Line(points={
              {-25.1,51.1},{-13.55,51.1},{-13.55,309},{236,309}}, color={0,0,127}));
      connect(fan.P, multiplex3_HVAC_Power.u3[1]) annotation (Line(points={{206.2,
              43.8},{206.2,295},{236,295}}, color={0,0,127}));
      connect(multiplex3_HVAC_Power.y[1], HVAC_Power_demand) annotation (Line(
            points={{259,301.333},{280,301.333},{280,302},{456,302}}, color={0,0,
              127}));
      connect(T_Supply.port_b, senVolFlo.port_a)
        annotation (Line(points={{252,24},{280,24}}, color={0,127,255}));
      connect(senVolFlo.port_b, port_supply) annotation (Line(points={{300,24},{
              376,24},{376,120},{434,120}}, color={0,127,255}));
      connect(senVolFlo.V_flow, fanControl.VFR_feedback) annotation (Line(
            points={{290,35},{290,94},{194.4,94},{194.4,95}}, color={0,0,127}));
      connect(fanControl.Fan_MFR_setpoint, fan.m_flow_in)
        annotation (Line(points={{182,80},{182,50.4}}, color={0,0,127}));
      connect(fanControl.VFR_setpoint, Fan_Flowrate_setpoint) annotation (Line(
            points={{169.6,95.4},{-88,95.4},{-88,510},{362,510}}, color={0,0,127}));
      connect(CoolingCoil_OnOff_Command, sinSpeDX.on) annotation (Line(points={{
              186,462},{-180,462},{-180,48.2},{-88.9,48.2}}, color={255,0,255}));
      connect(OA_Damper_mixing_command, MixingDamper.y) annotation (Line(points=
             {{-428,380},{-233,380},{-233,42.2}}, color={0,0,127}));
      connect(multiplex4_Temperatures.u1[1], T_OA_DB.T) annotation (Line(points=
             {{238,251},{228,251},{228,252},{-330,252},{-330,137}}, color={0,0,127}));
      connect(multiplex4_Temperatures.u2[1], T_Mixed.T) annotation (Line(points=
             {{238,245},{234,245},{234,244},{-164,244},{-164,35}}, color={0,0,127}));
      connect(T_Supply.T, multiplex4_Temperatures.u3[1]) annotation (Line(
            points={{242,35},{242,142},{220,142},{220,239},{238,239}}, color={0,
              0,127}));
      connect(T_Return.T, multiplex4_Temperatures.u4[1]) annotation (Line(
            points={{256,-125},{258,-125},{258,-116},{312,-116},{312,154},{238,154},
              {238,233}}, color={0,0,127}));
      connect(multiplex4_Temperatures.y[1], HVAC_Temperature_sensors)
        annotation (Line(points={{261,242},{458,242},{458,250}}, color={0,0,127}));
      connect(port_outside_inlet, T_OA_DB.port_a) annotation (Line(points={{-414,
              118},{-378,118},{-378,126},{-340,126}}, color={0,127,255}));
      connect(debug_T_CoolingCoil.T, debug_T_CC) annotation (Line(points={{14,35},
              {18,35},{18,394},{446,394}}, color={0,0,127}));
      connect(debug_T_HeatingCoil.T, debug_T_HC) annotation (Line(points={{132,35},
              {132,356},{450,356}}, color={0,0,127}));
      connect(T_Return.port_a, senMasFra.port_a)
        annotation (Line(points={{246,-136},{208,-136}}, color={0,127,255}));
      connect(senMasFra.port_b, MixingDamper.port_Ret) annotation (Line(points={
              {188,-136},{-8,-136},{-8,-13.6},{-202,-13.6}}, color={0,127,255}));
      connect(senMasFra.X, HR) annotation (Line(points={{198,-147},{210,-147},{210,
              -166},{402,-166},{402,82},{462,82}}, color={0,0,127}));
      connect(TOA, T_OA_DB.T) annotation (Line(points={{458,164},{336,164},{336,
              186},{-330,186},{-330,137}}, color={0,0,127}));
      connect(T_Return.T, TR) annotation (Line(points={{256,-125},{258,-125},{258,
              -116},{312,-116},{312,200},{434,200},{434,202},{458,202}}, color={
              0,0,127}));
      connect(sinSpeDX.P, add3_1.u1) annotation (Line(points={{-25.1,51.1},{-13.55,
              51.1},{-13.55,309},{194,309},{194,334},{220,334},{220,344},{236,344}},
            color={0,0,127}));
      connect(fan.P, add3_1.u3) annotation (Line(points={{206.2,43.8},{206.2,295},
              {226,295},{226,322},{232,322},{232,328},{236,328}}, color={0,0,127}));
      connect(HVAC_Tot_H_Power, add3_1.y) annotation (Line(points={{460,-24},{380,
              -24},{380,336},{259,336}}, color={0,0,127}));
      connect(T_OutsideAir, sinSpeDX.TConIn) annotation (Line(points={{-422,178},
              {-376,178},{-376,152},{-122,152},{-122,33.7},{-88.9,33.7}}, color=
             {0,0,127}));
      connect(TM, T_Mixed.T) annotation (Line(points={{-106,-62},{-164,76},{-164,
              35}}, color={0,0,127}));
      connect(debug_T_CoolingCoil.port_b, hea.port_a) annotation (Line(points={{
              24,24},{42,24},{42,25},{60,25}}, color={0,127,255}));
      connect(hea.port_b, debug_T_HeatingCoil.port_a) annotation (Line(points={{
              98,25},{111,25},{111,24},{122,24}}, color={0,127,255}));
      connect(T_HeatingCoil_Command, hea.u) annotation (Line(points={{246,452},{
              41,452},{41,37.6},{56.2,37.6}}, color={0,0,127}));
      connect(T_Supply.T, TS) annotation (Line(points={{242,35},{242,62},{264,62},
              {264,-108},{-160,-108}}, color={0,0,127}));
      connect(hea.Q_flow, add3_1.u2) annotation (Line(points={{99.9,37.6},{99.9,
              187.8},{236,187.8},{236,336}}, color={0,0,127}));
      connect(multiplex3_HVAC_Power.u2[1], hea.Q_flow) annotation (Line(points={
              {236,302},{168,302},{168,37.6},{99.9,37.6}}, color={0,0,127}));
      connect(T_OA_DB.port_b, senVolFlo1.port_a)
        annotation (Line(points={{-320,126},{-300,126}}, color={0,127,255}));
      connect(MixingDamper.port_Out, senVolFlo1.port_b) annotation (Line(points=
             {{-264,23.6},{-264,75.8},{-280,75.8},{-280,126}}, color={0,127,255}));
      connect(senVolFlo1.V_flow, OA_VFR) annotation (Line(points={{-290,137},{38,
              137},{38,434},{448,434},{448,448}}, color={0,0,127}));
      connect(MixingDamper.y_actual, realValue.numberPort) annotation (Line(
            points={{-217.5,26.7},{-217.5,53.35},{-203.5,53.35},{-203.5,80}},
            color={0,0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-400,-40},{420,
                400}}), graphics={Rectangle(
                  extent={{-402,402},{422,-42}},
                  lineColor={255,0,255},
                  fillColor={175,175,175},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-258,170},{234,-34}},
                  lineColor={0,0,0},
                  fillColor={175,175,175},
                  fillPattern=FillPattern.None,
                  textString="CAV")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-40},{
                420,400}}), graphics={Text(
                  extent={{-178,-166},{98,-190}},
                  lineColor={0,0,0},
                  textString="ASHRAE System 3 - CAV ",
                  fontSize=18,
                  textStyle={TextStyle.Bold})}),
        experiment(
          StopTime=31540000,
          Interval=3600,
          __Dymola_Algorithm="Dassl"));
    end System3CAV;

    model Schedule
      Modelica.Blocks.Interfaces.IntegerInput Day annotation (Placement(
            transformation(extent={{-524,228},{-484,268}}), iconTransformation(
              extent={{-524,228},{-484,268}})));
      Modelica.Blocks.Interfaces.IntegerInput Hour annotation (Placement(
            transformation(extent={{-526,312},{-486,352}}), iconTransformation(
              extent={{-526,312},{-486,352}})));
      Modelica.Blocks.Logical.Or is_Night1
        annotation (Placement(transformation(extent={{68,-30},{88,-10}})));
      Modelica.Blocks.Sources.RealExpression Saturday(y=6)
        annotation (Placement(transformation(extent={{-468,110},{-434,166}})));
      Modelica.Blocks.Math.IntegerToReal integerToReal
        annotation (Placement(transformation(extent={{-448,324},{-428,344}})));
      Modelica.Blocks.Math.IntegerToReal integerToReal1
        annotation (Placement(transformation(extent={{-442,274},{-422,294}})));
      Modelica.Blocks.Sources.RealExpression Friday(y=5)
        annotation (Placement(transformation(extent={{-468,170},{-434,226}})));
      Modelica.Blocks.Sources.RealExpression Sunday(y=7)
        annotation (Placement(transformation(extent={{-466,50},{-432,106}})));
      Modelica.Blocks.Sources.RealExpression End_of_day(y=18)
        annotation (Placement(transformation(extent={{-464,-66},{-430,-10}})));
      Modelica.Blocks.Sources.RealExpression Morning(y=5)
        annotation (Placement(transformation(extent={{-464,-6},{-430,50}})));
      Modelica.Blocks.Sources.RealExpression Night(y=22)
        annotation (Placement(transformation(extent={{-470,-122},{-416,-66}})));
      Modelica.Blocks.Logical.LessEqual is_weekday
        annotation (Placement(transformation(extent={{-90,322},{-44,346}})));
      Modelica.Blocks.Logical.GreaterEqual is_Weekend
        annotation (Placement(transformation(extent={{-154,212},{-94,260}})));
      Modelica.Blocks.Logical.Not not1
        annotation (Placement(transformation(extent={{-106,174},{-86,194}})));
      Modelica.Blocks.Logical.And is_Saturday
        annotation (Placement(transformation(extent={{-56,196},{-16,236}})));
      Modelica.Blocks.Logical.LessEqual is_weekday1
        annotation (Placement(transformation(extent={{-90,-70},{-60,-44}})));
      Modelica.Blocks.Logical.GreaterEqual is_Weekend1
        annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
      Modelica.Blocks.Logical.And is_Night_Weekday
        annotation (Placement(transformation(extent={{164,70},{206,112}})));
      Modelica.Blocks.Logical.And is_Day_Weekday
        annotation (Placement(transformation(extent={{164,10},{202,48}})));
      Modelica.Blocks.Logical.Not not2
        annotation (Placement(transformation(extent={{126,-42},{146,-22}})));
      Modelica.Blocks.Logical.GreaterEqual is_Weekend2
        annotation (Placement(transformation(extent={{-88,-138},{-68,-118}})));
      Modelica.Blocks.Logical.Or is_Night2
        annotation (Placement(transformation(extent={{66,-140},{86,-120}})));
      Modelica.Blocks.Logical.And is_Night_Saturday
        annotation (Placement(transformation(extent={{194,-96},{224,-66}})));
      Modelica.Blocks.Logical.Not not3
        annotation (Placement(transformation(extent={{134,-196},{154,-176}})));
      Modelica.Blocks.Logical.And is_Day_Saturday
        annotation (Placement(transformation(extent={{194,-150},{214,-130}})));
      Modelica.Blocks.Interfaces.BooleanOutput isNight annotation (Placement(
            transformation(extent={{408,266},{448,306}}), iconTransformation(
              extent={{408,266},{448,306}})));
      Modelica.Blocks.Interfaces.BooleanOutput isDay annotation (Placement(
            transformation(extent={{410,318},{450,358}}), iconTransformation(
              extent={{410,318},{450,358}})));
      Modelica.Blocks.Interfaces.BooleanOutput isSunday annotation (Placement(
            transformation(extent={{410,212},{442,244}}), iconTransformation(
              extent={{410,212},{442,244}})));
      Modelica.Blocks.Logical.Or is_Night_Final
        annotation (Placement(transformation(extent={{290,262},{310,282}})));
      Modelica.Blocks.Logical.Or is_Day_final
        annotation (Placement(transformation(extent={{294,206},{314,226}})));
      Modelica.Blocks.Logical.GreaterEqual greaterEqual
        annotation (Placement(transformation(extent={{-170,108},{-150,128}})));
    equation
      connect(Day, integerToReal.u) annotation (Line(points={{-504,248},{-490,248},
              {-490,334},{-450,334}}, color={255,127,0}));
      connect(Hour, integerToReal1.u) annotation (Line(points={{-506,332},{-476,
              332},{-476,284},{-444,284}}, color={255,127,0}));
      connect(integerToReal.y, is_weekday.u1)
        annotation (Line(points={{-427,334},{-94.6,334}}, color={0,0,127}));
      connect(Friday.y, is_weekday.u2) annotation (Line(points={{-432.3,198},{-298,
              198},{-298,324.4},{-94.6,324.4}}, color={0,0,127}));
      connect(Saturday.y, is_Weekend.u2) annotation (Line(points={{-432.3,138},{
              -292,138},{-292,216.8},{-160,216.8}}, color={0,0,127}));
      connect(is_Weekend.u1, is_weekday.u1) annotation (Line(points={{-160,236},
              {-242,236},{-242,334},{-94.6,334}}, color={0,0,127}));
      connect(is_Weekend.y, is_Saturday.u1) annotation (Line(points={{-91,236},{
              -84,236},{-84,216},{-60,216}}, color={255,0,255}));
      connect(is_Saturday.u2, not1.y) annotation (Line(points={{-60,200},{-70,200},
              {-70,184},{-85,184}}, color={255,0,255}));
      connect(is_weekday.y, is_Night_Weekday.u1) annotation (Line(points={{-41.7,
              334},{-4,334},{-4,91},{159.8,91}}, color={255,0,255}));
      connect(is_Weekend1.u1, integerToReal1.y) annotation (Line(points={{-86,-2},
              {-216,-2},{-216,284},{-421,284}}, color={0,0,127}));
      connect(is_weekday1.u1, integerToReal1.y) annotation (Line(points={{-93,-57},
              {-216,-57},{-216,284},{-421,284}}, color={0,0,127}));
      connect(is_Weekend1.u2, Night.y) annotation (Line(points={{-86,-10},{-258,
              -10},{-258,-94},{-413.3,-94}}, color={0,0,127}));
      connect(is_weekday1.u2, Morning.y) annotation (Line(points={{-93,-67.4},{-278.5,
              -67.4},{-278.5,22},{-428.3,22}}, color={0,0,127}));
      connect(is_weekday1.y, is_Night1.u2) annotation (Line(points={{-58.5,-57},
              {3.75,-57},{3.75,-28},{66,-28}}, color={255,0,255}));
      connect(is_Night1.u1, is_Weekend1.y) annotation (Line(points={{66,-20},{1,
              -20},{1,-2},{-63,-2}}, color={255,0,255}));
      connect(is_Night1.y, is_Night_Weekday.u2) annotation (Line(points={{89,-20},
              {120,-20},{120,74.2},{159.8,74.2}}, color={255,0,255}));
      connect(is_Day_Weekday.u1, is_Night_Weekday.u1) annotation (Line(points={{
              160.2,29},{140,29},{140,91},{159.8,91}}, color={255,0,255}));
      connect(not2.u, is_Night_Weekday.u2) annotation (Line(points={{124,-32},{110,
              -32},{110,-20},{120,-20},{120,74.2},{159.8,74.2}}, color={255,0,255}));
      connect(not2.y, is_Day_Weekday.u2) annotation (Line(points={{147,-32},{150,
              -32},{150,13.8},{160.2,13.8}}, color={255,0,255}));
      connect(is_Weekend2.u1, integerToReal1.y) annotation (Line(points={{-90,-128},
              {-152,-128},{-152,-94},{-212,-94},{-212,-54},{-216,-54},{-216,284},
              {-421,284}}, color={0,0,127}));
      connect(is_Weekend2.u2, End_of_day.y) annotation (Line(points={{-90,-136},
              {-262,-136},{-262,-38},{-428.3,-38}}, color={0,0,127}));
      connect(is_Night2.u1, is_Night1.u2) annotation (Line(points={{64,-130},{40,
              -130},{40,-28},{66,-28}}, color={255,0,255}));
      connect(is_Night2.u2, is_Weekend2.y) annotation (Line(points={{64,-138},{-4,
              -138},{-4,-128},{-67,-128}}, color={255,0,255}));
      connect(is_Saturday.y, is_Night_Saturday.u1) annotation (Line(points={{-14,
              216},{26,216},{26,204},{98,204},{98,-81},{191,-81}}, color={255,0,
              255}));
      connect(is_Night2.y, is_Night_Saturday.u2) annotation (Line(points={{87,-130},
              {140,-130},{140,-93},{191,-93}}, color={255,0,255}));
      connect(is_Day_Saturday.u1, is_Night_Saturday.u1) annotation (Line(points=
             {{192,-140},{172,-140},{172,-81},{191,-81}}, color={255,0,255}));
      connect(is_Day_Saturday.u2, not3.y) annotation (Line(points={{192,-148},{172,
              -148},{172,-186},{155,-186}}, color={255,0,255}));
      connect(not3.u, is_Night_Saturday.u2) annotation (Line(points={{132,-186},
              {120,-186},{120,-130},{140,-130},{140,-93},{191,-93}}, color={255,
              0,255}));
      connect(isNight, isNight)
        annotation (Line(points={{428,286},{428,286}}, color={255,0,255}));
      connect(is_Night_Weekday.y, is_Night_Final.u1) annotation (Line(points={{208.1,
              91},{226,91},{226,272},{288,272}}, color={255,0,255}));
      connect(is_Night_Saturday.y, is_Night_Final.u2) annotation (Line(points={{
              225.5,-81},{238,-81},{238,264},{288,264}}, color={255,0,255}));
      connect(is_Day_Weekday.y, is_Day_final.u1) annotation (Line(points={{203.9,
              29},{258,29},{258,216},{292,216}}, color={255,0,255}));
      connect(is_Day_Saturday.y, is_Day_final.u2) annotation (Line(points={{215,
              -140},{272,-140},{272,208},{292,208}}, color={255,0,255}));
      connect(is_Night_Final.y, isNight) annotation (Line(points={{311,272},{364,
              272},{364,286},{428,286}}, color={255,0,255}));
      connect(is_Day_final.y, isDay) annotation (Line(points={{315,216},{322,216},
              {322,218},{382,218},{382,338},{430,338}}, color={255,0,255}));
      connect(greaterEqual.u1, is_weekday.u1) annotation (Line(points={{-172,118},
              {-206,118},{-206,228},{-242,228},{-242,334},{-94.6,334}}, color={0,
              0,127}));
      connect(greaterEqual.u2, Sunday.y) annotation (Line(points={{-172,110},{-210,
              110},{-210,78},{-430.3,78}}, color={0,0,127}));
      connect(isSunday, greaterEqual.y) annotation (Line(points={{426,228},{154,
              228},{154,118},{-149,118}}, color={255,0,255}));
      connect(not1.u, greaterEqual.y) annotation (Line(points={{-108,184},{-120,
              184},{-120,118},{-149,118}}, color={255,0,255}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-480,80},{400,
                360}}), graphics={Rectangle(
                  extent={{-480,360},{400,82}},
                  lineColor={255,0,255},
                  fillColor={175,175,175},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-480,276},{-2,234}},
                  lineColor={0,0,0},
                  textString="Day"),Text(
                  extent={{-476,356},{2,314}},
                  lineColor={0,0,0},
                  textString="Hour"),Text(
                  extent={{-2,364},{400,322}},
                  lineColor={0,0,0},
                  textString="isDay"),Text(
                  extent={{-4,310},{398,268}},
                  lineColor={0,0,0},
                  textString="isNight"),Text(
                  extent={{0,258},{402,216}},
                  lineColor={0,0,0},
                  textString="isSunday")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-480,80},{400,
                360}})),
        experiment(
          StopTime=31540000,
          Interval=60,
          __Dymola_Algorithm="Dassl"));
    end Schedule;

    model FanControl

      Modelica.Blocks.Interfaces.RealInput VFR_setpoint
        annotation (Placement(transformation(extent={{-144,14},{-104,54}})));
      Modelica.Blocks.Interfaces.RealInput VFR_feedback annotation (Placement(
            transformation(
            extent={{-20,-20},{20,20}},
            rotation=180,
            origin={124,30})));
      Modelica.Blocks.Interfaces.RealOutput Fan_MFR_setpoint annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-120})));
      Buildings.Controls.Continuous.LimPID MFR_P(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        k=0.1,
        Ti=15,
        yMax=3) annotation (Placement(transformation(extent={{-8,20},{12,40}})));
    equation
      connect(VFR_setpoint, MFR_P.u_s) annotation (Line(points={{-124,34},{-68,34},
              {-68,30},{-10,30}}, color={0,0,127}));
      connect(VFR_feedback, MFR_P.u_m) annotation (Line(points={{124,30},{80,30},
              {80,4},{2,4},{2,18}}, color={0,0,127}));
      connect(MFR_P.y, Fan_MFR_setpoint) annotation (Line(points={{13,30},{20,30},
              {20,-120},{0,-120}}, color={0,0,127}));
      annotation ();
    end FanControl;

    package Medium = Buildings.Media.Air "Buildings library air media package";

    System3CAV system3CAV(redeclare package Medium = Medium, heaNomPow=14001)
      annotation (Placement(transformation(extent={{-68,-72},{6,-20}})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat
      annotation (Placement(transformation(extent={{-564,-50},{-544,-30}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
          transformation(extent={{-512,-60},{-472,-20}}), iconTransformation(
            extent={{-324,28},{-304,48}})));
    Buildings.Utilities.Time.CalendarTime calTim(zerTim=Buildings.Utilities.Time.Types.ZeroTime.NY2017,
        yearRef=2017)
      annotation (Placement(transformation(extent={{-492,82},{-460,114}})));
    Schedule schedule
      annotation (Placement(transformation(extent={{-432,82},{-358,114}})));
    Buildings.ThermalZones.EnergyPlus.ThermalZone zon(
      zoneName="Core_ZN",
      redeclare package Medium = Medium,
      T_start(displayUnit="degC") = 288.65,
      nPorts=2)
      annotation (Placement(transformation(extent={{100,64},{140,104}})));
    inner Buildings.ThermalZones.EnergyPlus.Building building(
      generatePortableFMU=true, verbosity=Buildings.ThermalZones.EnergyPlus.Types.Verbosity.Verbose)
      "Building model"
      annotation (Placement(transformation(extent={{112,142},{132,162}})));

    Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
      annotation (Placement(transformation(extent={{-172,166},{-152,186}})));
    Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
      annotation (Placement(transformation(extent={{-172,206},{-152,226}})));
    Modelica.Blocks.Routing.Multiplex3 mul "Multiplex for gains"
      annotation (Placement(transformation(extent={{-120,166},{-100,186}})));
    Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
      annotation (Placement(transformation(extent={{-194,126},{-174,146}})));
    Buildings.Fluid.Sources.Outside out(redeclare package Medium = Medium,
        nPorts=2)
      annotation (Placement(transformation(extent={{-450,-50},{-430,-30}})));
    CAVControlv2 cAVControlv2_1(designVFR=0.447163, minOA=0.080548)
      annotation (Placement(transformation(extent={{-66,24},{8,82}})));
    CAVControlv2 cAVControlv2_2(designVFR=0.365803, minOA=0.061060)
      annotation (Placement(transformation(extent={{-68,-144},{6,-86}})));
    System3CAV system3CAV1(redeclare package Medium = Medium, heaNomPow=11215.83)
      annotation (Placement(transformation(extent={{-72,-234},{2,-182}})));
    CAVControlv2 cAVControlv2_3(designVFR=0.357318, minOA=0.036222)
      annotation (Placement(transformation(extent={{-70,-312},{4,-254}})));
    System3CAV system3CAV2(redeclare package Medium = Medium, heaNomPow=9804.71)
      annotation (Placement(transformation(extent={{-74,-402},{0,-350}})));
    CAVControlv2 cAVControlv2_4(designVFR=0.367676, minOA=0.061060)
      annotation (Placement(transformation(extent={{-72,-478},{2,-420}})));
    System3CAV system3CAV3(redeclare package Medium = Medium, heaNomPow=11257.89)
      annotation (Placement(transformation(extent={{-76,-568},{-2,-516}})));
    CAVControlv2 cAVControlv2_5(designVFR=0.343483, minOA=0.036222)
      annotation (Placement(transformation(extent={{-78,-640},{-4,-582}})));
    System3CAV system3CAV4(redeclare package Medium = Medium, heaNomPow=9494)
      annotation (Placement(transformation(extent={{-82,-730},{-8,-678}})));
    Buildings.Fluid.Sources.Outside out1(redeclare package Medium = Medium,
        nPorts=4)
      annotation (Placement(transformation(extent={{-442,-224},{-422,-204}})));
    Buildings.Fluid.Sources.Outside out2(redeclare package Medium = Medium,
        nPorts=4)
      annotation (Placement(transformation(extent={{-440,-396},{-420,-376}})));
    Buildings.Fluid.Sources.Outside out3(redeclare package Medium = Medium,
        nPorts=4)
      annotation (Placement(transformation(extent={{-466,-558},{-446,-538}})));
    Buildings.Fluid.Sources.Outside out4(redeclare package Medium = Medium,
        nPorts=4)
      annotation (Placement(transformation(extent={{-444,-728},{-424,-708}})));


    Buildings.ThermalZones.EnergyPlus.ThermalZone zon1(
      zoneName="Perimeter_ZN_1",
      redeclare package Medium = Medium,
      T_start=288.65,
      nPorts=4)
      annotation (Placement(transformation(extent={{98,-204},{138,-164}})));
    Buildings.ThermalZones.EnergyPlus.ThermalZone zon2(
      zoneName="Perimeter_ZN_2",
      redeclare package Medium = Medium,
      T_start=288.65,
      nPorts=4)
      annotation (Placement(transformation(extent={{98,-338},{138,-298}})));
    Buildings.ThermalZones.EnergyPlus.ThermalZone zon3(
      zoneName="Perimeter_ZN_3",
      redeclare package Medium = Medium,
      T_start=288.65,
      nPorts=4)
      annotation (Placement(transformation(extent={{100,-508},{140,-468}})));
    Buildings.ThermalZones.EnergyPlus.ThermalZone zon4(
      zoneName="Perimeter_ZN_4",
      redeclare package Medium = Medium,
      T_start=288.65,
      nPorts=4)
      annotation (Placement(transformation(extent={{98,-670},{138,-630}})));
    Buildings.Airflow.Multizone.ZonalFlow_ACS infCore1(redeclare package Medium =
          Medium, V=113.45)
      annotation (Placement(transformation(extent={{-254,-160},{-234,-140}})));
    Modelica.Blocks.Sources.Constant infCoreACH1(k=0.000073611)
      annotation (Placement(transformation(extent={{-288,-130},{-268,-110}})));
    Buildings.Airflow.Multizone.ZonalFlow_ACS infCore2(redeclare package Medium =
          Medium, V=67.30)
      annotation (Placement(transformation(extent={{-258,-332},{-238,-312}})));
    Modelica.Blocks.Sources.Constant infCoreACH2(k=0.000082778)
      annotation (Placement(transformation(extent={{-292,-302},{-272,-282}})));
    Buildings.Airflow.Multizone.ZonalFlow_ACS infCore3(redeclare package Medium =
          Medium, V=113.45)
      annotation (Placement(transformation(extent={{-254,-510},{-234,-490}})));
    Modelica.Blocks.Sources.Constant infCoreACH3(k=0.000073611)
      annotation (Placement(transformation(extent={{-288,-480},{-268,-460}})));
    Buildings.Airflow.Multizone.ZonalFlow_ACS infCore4(redeclare package Medium =
          Medium, V=67.30)
      annotation (Placement(transformation(extent={{-248,-674},{-228,-654}})));
    Modelica.Blocks.Sources.Constant infCoreACH4(k=0.000082778)
      annotation (Placement(transformation(extent={{-282,-644},{-262,-624}})));
    Modelica.Blocks.Logical.And Daytime
      annotation (Placement(transformation(extent={{-104,120},{-84,140}})));
    Buildings.Controls.OBC.CDL.Logical.Not not4
      annotation (Placement(transformation(extent={{-142,82},{-122,102}})));
    Buildings.Utilities.IO.SignalExchange.Read senDay(
      y(unit="1"),
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
      description="isDaytime") "read daytime"
      annotation (Placement(transformation(extent={{-34,120},{-14,140}})));

    Buildings.Utilities.IO.SignalExchange.Overwrite oveCC1(u(
        unit="1",
        min=0,
        max=1), description="CC On/Off for Core zone")
      annotation (Placement(transformation(extent={{268,162},{288,182}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet1(u(
        unit="1",
        min=0,
        max=1), description="Heating Coil setpoint override for core zone")
      annotation (Placement(transformation(extent={{268,136},{288,156}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveDSet1(u(
        unit="1",
        min=0,
        max=1), description="Damper setting override for core zone")
      annotation (Placement(transformation(extent={{268,110},{288,130}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveVFRSet1(u(
        unit="1",
        min=0,
        max=100), description="Fan override for core zone")
      annotation (Placement(transformation(extent={{268,84},{288,104}})));
    Buildings.Utilities.IO.SignalExchange.Read senTRoom1(
      y(unit="K"),
      description="Room temperature of core zone",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
      zone="1")
      annotation (Placement(transformation(extent={{268,58},{288,78}})));

    Buildings.Utilities.IO.SignalExchange.Read senHPow(
      y(unit="W"),
      description="Total HVAC Power demand",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower)
      annotation (Placement(transformation(extent={{460,-68},{480,-48}})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal
      annotation (Placement(transformation(extent={{-70,120},{-50,140}})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal1
      annotation (Placement(transformation(extent={{234,162},{254,182}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean
      annotation (Placement(transformation(extent={{302,162},{322,182}})));
    Modelica.Blocks.Math.BooleanToReal booleanToReal2
      annotation (Placement(transformation(extent={{238,-122},{258,-102}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveCC2(u(
        unit="1",
        min=0,
        max=1), description="CC On/Off for Perimeter zone 1")
      annotation (Placement(transformation(extent={{272,-122},{292,-102}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean1
      annotation (Placement(transformation(extent={{306,-122},{326,-102}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet2(u(
        unit="1",
        min=0,
        max=1), description="Heating Coil setpoint override for Perimeter zone 1")
      annotation (Placement(transformation(extent={{272,-148},{292,-128}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveDSet2(u(
        unit="1",
        min=0,
        max=1), description="Damper setting override for Perimeter zone 1")
      annotation (Placement(transformation(extent={{272,-174},{292,-154}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveVFRSet2(u(
        unit="1",
        min=0,
        max=100), description="Fan override for Perimeter zone 1")
      annotation (Placement(transformation(extent={{272,-200},{292,-180}})));
    Buildings.Utilities.IO.SignalExchange.Read senTRoom2(
      y(unit="K"),
      description="Room temperature of Perimeter zone 1",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
      zone="2")
      annotation (Placement(transformation(extent={{272,-226},{292,-206}})));

    Modelica.Blocks.Math.BooleanToReal booleanToReal3
      annotation (Placement(transformation(extent={{240,-298},{260,-278}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveCC3(u(
        unit="1",
        min=0,
        max=1), description="CC On/Off for Perimeter zone 2")
      annotation (Placement(transformation(extent={{274,-298},{294,-278}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean2
      annotation (Placement(transformation(extent={{308,-298},{328,-278}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet3(u(
        unit="1",
        min=0,
        max=1), description="Heating Coil setpoint override for Perimeter zone 2")
      annotation (Placement(transformation(extent={{274,-324},{294,-304}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveDSet3(u(
        unit="1",
        min=0,
        max=1), description="Damper setting override for Perimeter zone 2")
      annotation (Placement(transformation(extent={{274,-350},{294,-330}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveVFRSet3(u(
        unit="1",
        min=0,
        max=100), description="Fan override for Perimeter zone 2")
      annotation (Placement(transformation(extent={{274,-376},{294,-356}})));
    Buildings.Utilities.IO.SignalExchange.Read senTRoom3(
      y(unit="K"),
      description="Room temperature of Perimeter zone 2",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
      zone="3")
      annotation (Placement(transformation(extent={{274,-402},{294,-382}})));

    Modelica.Blocks.Math.BooleanToReal booleanToReal4
      annotation (Placement(transformation(extent={{240,-454},{260,-434}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveCC4(u(
        unit="1",
        min=0,
        max=1), description="CC On/Off for Perimeter zone 3")
      annotation (Placement(transformation(extent={{274,-454},{294,-434}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean3
      annotation (Placement(transformation(extent={{308,-454},{328,-434}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet4(u(
        unit="1",
        min=0,
        max=1), description="Heating Coil setpoint override for Perimeter zone 3")
      annotation (Placement(transformation(extent={{274,-480},{294,-460}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveDSet4(u(
        unit="1",
        min=0,
        max=1), description="Damper setting override for Perimeter zone 3")
      annotation (Placement(transformation(extent={{274,-506},{294,-486}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveVFRSet4(u(
        unit="1",
        min=0,
        max=100), description="Fan override for Perimeter zone 3")
      annotation (Placement(transformation(extent={{274,-532},{294,-512}})));
    Buildings.Utilities.IO.SignalExchange.Read senTRoom4(
      y(unit="K"),
      description="Room temperature of Perimeter zone 3",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
      zone="4")
      annotation (Placement(transformation(extent={{274,-558},{294,-538}})));

    Modelica.Blocks.Math.BooleanToReal booleanToReal5
      annotation (Placement(transformation(extent={{242,-612},{262,-592}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveCC5(u(
        unit="1",
        min=0,
        max=1), description="CC On/Off for Perimeter zone 4")
      annotation (Placement(transformation(extent={{276,-612},{296,-592}})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean4
      annotation (Placement(transformation(extent={{310,-612},{330,-592}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveHCSet5(u(
        unit="1",
        min=0,
        max=1), description="Heating Coil setpoint override for Perimeter zone 4")
      annotation (Placement(transformation(extent={{276,-638},{296,-618}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveDSet5(u(
        unit="1",
        min=0,
        max=1), description="Damper setting override for Perimeter zone 4")
      annotation (Placement(transformation(extent={{276,-664},{296,-644}})));
    Buildings.Utilities.IO.SignalExchange.Overwrite oveVFRSet5(u(
        unit="1",
        min=0,
        max=100), description="Fan override for Perimeter zone 4")
      annotation (Placement(transformation(extent={{276,-690},{296,-670}})));
    Buildings.Utilities.IO.SignalExchange.Read senTRoom5(
      y(unit="K"),
      description="Room temperature of Perimeter zone 4",
      KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
      zone="5")
      annotation (Placement(transformation(extent={{276,-716},{296,-696}})));

    Modelica.Blocks.Math.MultiSum multiSum(k={1,1,1,1,1}, nu=5)
      annotation (Placement(transformation(extent={{432,-88},{444,-76}})));
  equation
    connect(weaDat.weaBus, weaBus) annotation (Line(
        points={{-544,-40},{-492,-40}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(schedule.Hour, calTim.hour) annotation (Line(points={{-434.186,
            110.8},{-446,110.8},{-446,110},{-452,110},{-452,108.24},{-458.4,
            108.24}},
          color={255,127,0}));
    connect(calTim.weekDay, schedule.Day) annotation (Line(points={{-458.4,91.6},
            {-456,91.6},{-456,92},{-452,92},{-452,101.2},{-434.018,101.2}},
          color={255,127,0}));
    connect(qRadGai_flow.y, mul.u1[1]) annotation (Line(
        points={{-151,216},{-132,216},{-132,183},{-122,183}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(qConGai_flow.y, mul.u2[1]) annotation (Line(
        points={{-151,176},{-122,176}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(mul.u3[1], qLatGai_flow.y) annotation (Line(points={{-122,169},{-132,
            169},{-132,136},{-173,136}}, color={0,0,127}));
    connect(weaBus, out.weaBus) annotation (Line(
        points={{-492,-40},{-470,-40},{-470,-39.8},{-450,-39.8}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(system3CAV.port_outside_inlet, out.ports[1]) annotation (Line(
          points={{-69.2634,-53.3273},{-102.2,-53.3273},{-102.2,-38},{-430,-38}},
          color={0,127,255}));
    connect(mul.y, zon.qGai_flow)
      annotation (Line(points={{-99,176},{98,176},{98,94}}, color={0,0,127}));
    connect(system3CAV.port_outside_outlet, out.ports[2]) annotation (Line(
          points={{-69.2634,-64.4364},{-253.632,-64.4364},{-253.632,-42},{-430,
            -42}},
          color={0,127,255}));
    connect(system3CAV.port_supply, zon.ports[1]) annotation (Line(points={{7.26341,
            -53.0909},{66,-53.0909},{66,0},{86,0},{86,64.9},{118,64.9}}, color={
            0,127,255}));
    connect(system3CAV.port_return, zon.ports[2]) annotation (Line(points={{7.4439,
            -63.9636},{122,-63.9636},{122,64.9}}, color={0,127,255}));
    connect(system3CAV.T_OutsideAir, weaBus.TDryBul) annotation (Line(points={{
            -70.5268,-22.1273},{-374,-22.1273},{-374,-12},{-460,-12},{-460,-40},
            {-492,-40}},
          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(cAVControlv2_1.isDay, schedule.isDay) annotation (Line(points={{
            -70.1933,76.8444},{-178,76.8444},{-178,112},{-246,112},{-246,
            111.486},{-355.477,111.486}},
                       color={255,0,255}));
    connect(cAVControlv2_1.isNight, schedule.isNight) annotation (Line(points={{
            -70.1933,65.5667},{-187.8,65.5667},{-187.8,105.543},{-355.645,
            105.543}},
          color={255,0,255}));
    connect(cAVControlv2_1.isSunday, schedule.isSunday) annotation (Line(points={{
            -70.1933,52.0333},{-199.8,52.0333},{-199.8,98.9143},{-355.814,
            98.9143}},
          color={255,0,255}));
    connect(cAVControlv2_1.HR_return, system3CAV.HR) annotation (Line(points={{-58.6,
            19.1667},{-58.6,6.2611},{-56.6293,6.2611},{-56.6293,-14.8}}, color={
            0,0,127}));
    connect(cAVControlv2_1.T_OA, system3CAV.TOA) annotation (Line(points={{
            -50.7067,18.8444},{-50.7067,6.4222},{-49.4098,6.4222},{-49.4098,
            -15.2727}},
          color={0,0,127}));
    connect(cAVControlv2_1.T_mixed, system3CAV.TM) annotation (Line(points={{-42.32,
            18.8444},{-42.32,8.4222},{-43.2732,8.4222},{-43.2732,-15.0364}},
          color={0,0,127}));
    connect(cAVControlv2_1.T_supp, system3CAV.TS) annotation (Line(points={{-34.92,
            18.8444},{-34.92,6.4222},{-36.0537,6.4222},{-36.0537,-14.8}}, color=
           {0,0,127}));
    connect(out1.weaBus, weaBus) annotation (Line(
        points={{-442,-213.8},{-466,-213.8},{-466,-40},{-492,-40}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(out1.weaBus, out2.weaBus) annotation (Line(
        points={{-442,-213.8},{-466,-213.8},{-466,-385.8},{-440,-385.8}},
        color={255,204,51},
        thickness=0.5));
    connect(out3.weaBus, out2.weaBus) annotation (Line(
        points={{-466,-547.8},{-466,-385.8},{-440,-385.8}},
        color={255,204,51},
        thickness=0.5));
    connect(out4.weaBus, out3.weaBus) annotation (Line(
        points={{-444,-717.8},{-466,-717.8},{-466,-547.8}},
        color={255,204,51},
        thickness=0.5));
    connect(out1.ports[1], system3CAV1.port_outside_inlet) annotation (Line(
          points={{-422,-211},{-248,-211},{-248,-215.327},{-73.2634,-215.327}},
          color={0,127,255}));
    connect(system3CAV1.port_outside_outlet, out1.ports[2]) annotation (Line(
          points={{-73.2634,-226.436},{-248.632,-226.436},{-248.632,-213},{-422,
            -213}}, color={0,127,255}));
    connect(system3CAV2.port_outside_inlet, out2.ports[1]) annotation (Line(
          points={{-75.2634,-383.327},{-249.632,-383.327},{-249.632,-383},{-420,
            -383}}, color={0,127,255}));
    connect(system3CAV2.port_outside_outlet, out2.ports[2]) annotation (Line(
          points={{-75.2634,-394.436},{-247.632,-394.436},{-247.632,-385},{-420,
            -385}}, color={0,127,255}));
    connect(system3CAV3.port_outside_inlet, out3.ports[1]) annotation (Line(
          points={{-77.2634,-549.327},{-262.632,-549.327},{-262.632,-545},{-446,
            -545}}, color={0,127,255}));
    connect(system3CAV3.port_outside_outlet, out3.ports[2]) annotation (Line(
          points={{-77.2634,-560.436},{-261.632,-560.436},{-261.632,-547},{-446,
            -547}}, color={0,127,255}));
    connect(system3CAV4.port_outside_inlet, out4.ports[1]) annotation (Line(
          points={{-83.2634,-711.327},{-254.632,-711.327},{-254.632,-715},{-424,
            -715}}, color={0,127,255}));
    connect(system3CAV4.port_outside_outlet, out4.ports[2]) annotation (Line(
          points={{-83.2634,-722.436},{-254.632,-722.436},{-254.632,-717},{-424,
            -717}}, color={0,127,255}));
    connect(system3CAV.T_OutsideAir, system3CAV1.T_OutsideAir) annotation (Line(
          points={{-70.5268,-22.1273},{-374,-22.1273},{-374,-12},{-398,-12},{
            -398,-184.127},{-74.5268,-184.127}},
                                            color={0,0,127}));
    connect(system3CAV2.T_OutsideAir, system3CAV1.T_OutsideAir) annotation (
        Line(points={{-76.5268,-352.127},{-398,-352.127},{-398,-184.127},{
            -74.5268,-184.127}},
                        color={0,0,127}));
    connect(system3CAV3.T_OutsideAir, system3CAV1.T_OutsideAir) annotation (
        Line(points={{-78.5268,-518.127},{-398,-518.127},{-398,-184.127},{
            -74.5268,-184.127}},
                        color={0,0,127}));
    connect(system3CAV4.T_OutsideAir, system3CAV1.T_OutsideAir) annotation (
        Line(points={{-84.5268,-680.127},{-398,-680.127},{-398,-184.127},{
            -74.5268,-184.127}},
                        color={0,0,127}));
    connect(cAVControlv2_2.isDay, schedule.isDay) annotation (Line(points={{
            -72.1933,-91.1556},{-72.1933,-92},{-178,-92},{-178,112},{-246,112},
            {-246,111.486},{-355.477,111.486}},
                                 color={255,0,255}));
    connect(cAVControlv2_2.isNight, schedule.isNight) annotation (Line(points={{
            -72.1933,-102.433},{-188,-102.433},{-188,66},{-187.8,66},{-187.8,
            105.543},{-355.645,105.543}},
                                 color={255,0,255}));
    connect(cAVControlv2_2.isSunday, schedule.isSunday) annotation (Line(points={{
            -72.1933,-115.967},{-72.1933,-114},{-198,-114},{-198,52.0333},{
            -199.8,52.0333},{-199.8,98.9143},{-355.814,98.9143}},
                                                           color={255,0,255}));
    connect(cAVControlv2_3.isDay, schedule.isDay) annotation (Line(points={{
            -74.1933,-259.156},{-178,-259.156},{-178,112},{-246,112},{-246,
            111.486},{-355.477,111.486}},
                       color={255,0,255}));
    connect(cAVControlv2_3.isNight, schedule.isNight) annotation (Line(points={{
            -74.1933,-270.433},{-188,-270.433},{-188,66},{-187.8,66},{-187.8,
            105.543},{-355.645,105.543}},
                                 color={255,0,255}));
    connect(cAVControlv2_3.isSunday, schedule.isSunday) annotation (Line(points={{
            -74.1933,-283.967},{-74.1933,-284},{-198,-284},{-198,52.0333},{
            -199.8,52.0333},{-199.8,98.9143},{-355.814,98.9143}},
                                                           color={255,0,255}));
    connect(cAVControlv2_4.isDay, schedule.isDay) annotation (Line(points={{
            -76.1933,-425.156},{-176,-425.156},{-176,-259.156},{-178,-259.156},
            {-178,112},{-246,112},{-246,111.486},{-355.477,111.486}},
                                                           color={255,0,255}));
    connect(cAVControlv2_4.isNight, schedule.isNight) annotation (Line(points={{
            -76.1933,-436.433},{-188,-436.433},{-188,66},{-187.8,66},{-187.8,
            105.543},{-355.645,105.543}},
                                 color={255,0,255}));
    connect(cAVControlv2_4.isSunday, schedule.isSunday) annotation (Line(points={{
            -76.1933,-449.967},{-76.1933,-450},{-198,-450},{-198,52.0333},{
            -199.8,52.0333},{-199.8,98.9143},{-355.814,98.9143}},
                                                           color={255,0,255}));
    connect(cAVControlv2_5.isDay, schedule.isDay) annotation (Line(points={{
            -82.1933,-587.156},{-176,-587.156},{-176,-259.156},{-178,-259.156},
            {-178,112},{-246,112},{-246,111.486},{-355.477,111.486}},
                                                           color={255,0,255}));
    connect(cAVControlv2_5.isNight, schedule.isNight) annotation (Line(points={{
            -82.1933,-598.433},{-188,-598.433},{-188,66},{-187.8,66},{-187.8,
            105.543},{-355.645,105.543}},
                                 color={255,0,255}));
    connect(cAVControlv2_5.isSunday, schedule.isSunday) annotation (Line(points={{
            -82.1933,-611.967},{-82.1933,-612},{-198,-612},{-198,52.0333},{
            -199.8,52.0333},{-199.8,98.9143},{-355.814,98.9143}},
                                                           color={255,0,255}));
    connect(cAVControlv2_2.HR_return, system3CAV1.HR) annotation (Line(points={{-60.6,
            -148.833},{-60.6,-160.739},{-60.6293,-160.739},{-60.6293,-176.8}},
          color={0,0,127}));
    connect(cAVControlv2_2.T_OA, system3CAV1.TOA) annotation (Line(points={{
            -52.7067,-149.156},{-52.7067,-161.578},{-53.4098,-161.578},{
            -53.4098,-177.273}},
          color={0,0,127}));
    connect(cAVControlv2_2.T_mixed, system3CAV1.TM) annotation (Line(points={{-44.32,
            -149.156},{-44.32,-163.578},{-47.2732,-163.578},{-47.2732,-177.036}},
          color={0,0,127}));
    connect(cAVControlv2_2.T_supp, system3CAV1.TS) annotation (Line(points={{-36.92,
            -149.156},{-36.92,-161.578},{-40.0537,-161.578},{-40.0537,-176.8}},
          color={0,0,127}));
    connect(cAVControlv2_3.HR_return, system3CAV2.HR) annotation (Line(points={{-62.6,
            -316.833},{-62.6,-332.739},{-62.6293,-332.739},{-62.6293,-344.8}},
          color={0,0,127}));
    connect(cAVControlv2_3.T_OA, system3CAV2.TOA) annotation (Line(points={{
            -54.7067,-317.156},{-54.7067,-332.578},{-55.4098,-332.578},{
            -55.4098,-345.273}},
          color={0,0,127}));
    connect(cAVControlv2_3.T_mixed, system3CAV2.TM) annotation (Line(points={{-46.32,
            -317.156},{-46.32,-331.578},{-49.2732,-331.578},{-49.2732,-345.036}},
          color={0,0,127}));
    connect(cAVControlv2_3.T_supp, system3CAV2.TS) annotation (Line(points={{-38.92,
            -317.156},{-38.92,-329.578},{-42.0537,-329.578},{-42.0537,-344.8}},
          color={0,0,127}));
    connect(cAVControlv2_4.HR_return, system3CAV3.HR) annotation (Line(points={{-64.6,
            -482.833},{-64.6,-498.739},{-64.6293,-498.739},{-64.6293,-510.8}},
          color={0,0,127}));
    connect(cAVControlv2_4.T_OA, system3CAV3.TOA) annotation (Line(points={{
            -56.7067,-483.156},{-56.7067,-496.578},{-57.4098,-496.578},{
            -57.4098,-511.273}},
          color={0,0,127}));
    connect(cAVControlv2_4.T_mixed, system3CAV3.TM) annotation (Line(points={{-48.32,
            -483.156},{-48.32,-498.578},{-51.2732,-498.578},{-51.2732,-511.036}},
          color={0,0,127}));
    connect(cAVControlv2_4.T_supp, system3CAV3.TS) annotation (Line(points={{-40.92,
            -483.156},{-40.92,-497.578},{-44.0537,-497.578},{-44.0537,-510.8}},
          color={0,0,127}));
    connect(cAVControlv2_5.HR_return, system3CAV4.HR) annotation (Line(points={{-70.6,
            -644.833},{-70.6,-659.739},{-70.6293,-659.739},{-70.6293,-672.8}},
          color={0,0,127}));
    connect(cAVControlv2_5.T_OA, system3CAV4.TOA) annotation (Line(points={{
            -62.7067,-645.156},{-62.7067,-658.578},{-63.4098,-658.578},{
            -63.4098,-673.273}},
          color={0,0,127}));
    connect(cAVControlv2_5.T_mixed, system3CAV4.TM) annotation (Line(points={{-54.32,
            -645.156},{-54.32,-659.578},{-57.2732,-659.578},{-57.2732,-673.036}},
          color={0,0,127}));
    connect(cAVControlv2_5.T_supp, system3CAV4.TS) annotation (Line(points={{-46.92,
            -645.156},{-46.92,-659.578},{-50.0537,-659.578},{-50.0537,-672.8}},
          color={0,0,127}));
    connect(system3CAV1.port_supply, zon1.ports[1]) annotation (Line(points={{3.26341,
            -215.091},{48.6317,-215.091},{48.6317,-203.1},{115,-203.1}}, color={
            0,127,255}));
    connect(system3CAV1.port_return, zon1.ports[2]) annotation (Line(points={{3.4439,
            -225.964},{51.7219,-225.964},{51.7219,-203.1},{117,-203.1}}, color={
            0,127,255}));
    connect(system3CAV2.port_supply, zon2.ports[1]) annotation (Line(points={{1.26341,
            -383.091},{48.6317,-383.091},{48.6317,-337.1},{115,-337.1}}, color={
            0,127,255}));
    connect(system3CAV2.port_return, zon2.ports[2]) annotation (Line(points={{1.4439,
            -393.964},{51.7219,-393.964},{51.7219,-337.1},{117,-337.1}}, color={
            0,127,255}));
    connect(system3CAV3.port_supply, zon3.ports[1]) annotation (Line(points={{
            -0.736585,-549.091},{45.6317,-549.091},{45.6317,-507.1},{117,-507.1}},
                                                                         color={
            0,127,255}));
    connect(system3CAV3.port_return, zon3.ports[2]) annotation (Line(points={{
            -0.556098,-559.964},{49.722,-559.964},{49.722,-507.1},{119,-507.1}},
                                                                       color={0,
            127,255}));
    connect(system3CAV4.port_supply, zon4.ports[1]) annotation (Line(points={{
            -6.73659,-711.091},{45.6317,-711.091},{45.6317,-669.1},{115,-669.1}},
                                                                         color={
            0,127,255}));
    connect(system3CAV4.port_return, zon4.ports[2]) annotation (Line(points={{-6.5561,
            -721.964},{46.7219,-721.964},{46.7219,-669.1},{117,-669.1}}, color={
            0,127,255}));
    connect(zon1.qGai_flow, mul.y) annotation (Line(points={{96,-174},{50,-174},
            {50,176},{-99,176}}, color={0,0,127}));
    connect(zon2.qGai_flow, mul.y) annotation (Line(points={{96,-308},{34,-308},
            {34,176},{-99,176}}, color={0,0,127}));
    connect(zon3.qGai_flow, mul.y) annotation (Line(points={{98,-478},{44,-478},
            {44,176},{-99,176}}, color={0,0,127}));
    connect(zon4.qGai_flow, mul.y) annotation (Line(points={{96,-640},{38,-640},
            {38,176},{-99,176}}, color={0,0,127}));
    connect(system3CAV.OA_VFR, cAVControlv2_1.OA_VFR) annotation (Line(points={{-30.278,
            -14.8},{-30.278,6.6},{-28.0133,6.6},{-28.0133,18.8444}},
          color={0,0,127}));
    connect(system3CAV1.OA_VFR, cAVControlv2_2.OA_VFR) annotation (Line(points={{-34.278,
            -176.8},{-34.278,-164.4},{-30.0133,-164.4},{-30.0133,-149.156}},
          color={0,0,127}));
    connect(system3CAV2.OA_VFR, cAVControlv2_3.OA_VFR) annotation (Line(points={{-36.278,
            -344.8},{-36.278,-331.4},{-32.0133,-331.4},{-32.0133,-317.156}},
          color={0,0,127}));
    connect(system3CAV3.OA_VFR, cAVControlv2_4.OA_VFR) annotation (Line(points={{-38.278,
            -510.8},{-38.278,-498.4},{-34.0133,-498.4},{-34.0133,-483.156}},
          color={0,0,127}));
    connect(system3CAV4.OA_VFR, cAVControlv2_5.OA_VFR) annotation (Line(points={{-44.278,
            -672.8},{-44.278,-660.4},{-40.0133,-660.4},{-40.0133,-645.156}},
          color={0,0,127}));
    connect(infCore4.port_a1, out4.ports[3]) annotation (Line(points={{-248,-658},
            {-336,-658},{-336,-719},{-424,-719}}, color={0,127,255}));
    connect(infCore4.port_b2, out4.ports[4]) annotation (Line(points={{-248,-670},
            {-336,-670},{-336,-721},{-424,-721}}, color={0,127,255}));
    connect(infCore4.port_b1, zon4.ports[3]) annotation (Line(points={{-228,-658},
            {-66,-658},{-66,-669.1},{119,-669.1}}, color={0,127,255}));
    connect(infCore4.port_a2, zon4.ports[4]) annotation (Line(points={{-228,-670},
            {-66,-670},{-66,-669.1},{121,-669.1}}, color={0,127,255}));
    connect(infCoreACH4.y, infCore4.ACS) annotation (Line(points={{-261,-634},{-254,
            -634},{-254,-654},{-249,-654}}, color={0,0,127}));
    connect(infCore3.port_a1, out3.ports[3]) annotation (Line(points={{-254,-494},
            {-350,-494},{-350,-549},{-446,-549}}, color={0,127,255}));
    connect(infCore3.port_b2, out3.ports[4]) annotation (Line(points={{-254,-506},
            {-350,-506},{-350,-551},{-446,-551}}, color={0,127,255}));
    connect(infCore3.port_b1, zon3.ports[3]) annotation (Line(points={{-234,-494},
            {-66,-494},{-66,-507.1},{121,-507.1}}, color={0,127,255}));
    connect(infCore3.port_a2, zon3.ports[4]) annotation (Line(points={{-234,-506},
            {-70,-506},{-70,-540},{104,-540},{104,-507.1},{123,-507.1}}, color={
            0,127,255}));
    connect(infCoreACH3.y, infCore3.ACS) annotation (Line(points={{-267,-470},{-267,
            -481},{-255,-481},{-255,-490}}, color={0,0,127}));
    connect(infCore2.port_a1, out2.ports[3]) annotation (Line(points={{-258,-316},
            {-340,-316},{-340,-387},{-420,-387}}, color={0,127,255}));
    connect(infCore2.port_b2, out2.ports[4]) annotation (Line(points={{-258,-328},
            {-340,-328},{-340,-389},{-420,-389}}, color={0,127,255}));
    connect(infCore2.port_b1, zon2.ports[3]) annotation (Line(points={{-238,-316},
            {-70,-316},{-70,-337.1},{119,-337.1}}, color={0,127,255}));
    connect(infCore2.port_a2, zon2.ports[4]) annotation (Line(points={{-238,-328},
            {-68,-328},{-68,-337.1},{121,-337.1}}, color={0,127,255}));
    connect(infCoreACH2.y, infCore2.ACS) annotation (Line(points={{-271,-292},{-266,
            -292},{-266,-312},{-259,-312}}, color={0,0,127}));
    connect(infCore1.port_a1, out1.ports[3]) annotation (Line(points={{-254,-144},
            {-340,-144},{-340,-215},{-422,-215}}, color={0,127,255}));
    connect(infCore1.port_b2, out1.ports[4]) annotation (Line(points={{-254,-156},
            {-340,-156},{-340,-217},{-422,-217}}, color={0,127,255}));
    connect(infCore1.port_b1, zon1.ports[3]) annotation (Line(points={{-234,-144},
            {-66,-144},{-66,-203.1},{119,-203.1}}, color={0,127,255}));
    connect(infCore1.port_a2, zon1.ports[4]) annotation (Line(points={{-234,-156},
            {-66,-156},{-66,-203.1},{121,-203.1}}, color={0,127,255}));
    connect(infCoreACH1.y, infCore1.ACS) annotation (Line(points={{-267,-120},{-262,
            -120},{-262,-140},{-255,-140}}, color={0,0,127}));
    connect(Daytime.u1, schedule.isDay) annotation (Line(points={{-106,130},{
            -144,130},{-144,112},{-246,112},{-246,111.486},{-355.477,111.486}},
          color={255,0,255}));
    connect(not4.y, Daytime.u2) annotation (Line(points={{-120,92},{-114,92},{-114,
            122},{-106,122}}, color={255,0,255}));
    connect(not4.u, schedule.isSunday) annotation (Line(points={{-144,92},{-172,
            92},{-172,98},{-199.8,98},{-199.8,98.9143},{-355.814,98.9143}},
          color={255,0,255}));
    connect(cAVControlv2_1.HC_Setpoint, oveHCSet1.u) annotation (Line(points={{
            -12.4733,18.8444},{-12,18.8444},{-12,10},{190,10},{190,146},{266,
            146}},
          color={0,0,127}));
    connect(oveHCSet1.y, system3CAV.T_HeatingCoil_Command) annotation (Line(
          points={{289,146},{304,146},{304,144},{318,144},{318,8},{-16.561,8},{
            -16.561,-14.8}},
                     color={0,0,127}));
    connect(cAVControlv2_1.Damper_Setting, oveDSet1.u) annotation (Line(points={{
            -5.44333,19.0056},{-6,19.0056},{-6,14},{198,14},{198,120},{266,120}},
          color={0,0,127}));
    connect(oveDSet1.y, system3CAV.OA_Damper_mixing_command) annotation (Line(
          points={{289,120},{312,120},{312,4},{-9.88293,4},{-9.88293,-14.8}},
          color={0,0,127}));
    connect(oveVFRSet1.u, cAVControlv2_1.VFR_setting) annotation (Line(points={{266,94},
            {202,94},{202,19.3278},{3.19,19.3278}},         color={0,0,127}));
    connect(oveVFRSet1.y, system3CAV.Fan_Flowrate_setpoint) annotation (Line(
          points={{289,94},{306,94},{306,-4},{0.404878,-4},{0.404878,-14.8}},
          color={0,0,127}));
    connect(zon.TAir, senTRoom1.u) annotation (Line(points={{141,97.8},{180,97.8},
            {180,68},{266,68}}, color={0,0,127}));
    connect(senTRoom1.y, cAVControlv2_1.T_return) annotation (Line(points={{289,68},
            {300,68},{300,30},{-74,30},{-74,18.5222},{-67.2333,18.5222}},
          color={0,0,127}));
    connect(Daytime.y, booleanToReal.u)
      annotation (Line(points={{-83,130},{-72,130}}, color={255,0,255}));
    connect(booleanToReal.y, senDay.u)
      annotation (Line(points={{-49,130},{-36,130}}, color={0,0,127}));
    connect(booleanToReal1.y, oveCC1.u)
      annotation (Line(points={{255,172},{266,172}}, color={0,0,127}));
    connect(cAVControlv2_1.CC_OnOff, booleanToReal1.u) annotation (Line(points={{
            -20.7367,18.6833},{-20.7367,36},{182,36},{182,172},{232,172}},
          color={255,0,255}));
    connect(oveCC1.y, realToBoolean.u)
      annotation (Line(points={{289,172},{300,172}}, color={0,0,127}));
    connect(realToBoolean.y, system3CAV.CoolingCoil_OnOff_Command) annotation (
        Line(points={{323,172},{326,172},{326,-8},{-24.322,-8},{-24.322,
            -15.0364}},
          color={255,0,255}));
    connect(booleanToReal2.y, oveCC2.u)
      annotation (Line(points={{259,-112},{270,-112}}, color={0,0,127}));
    connect(oveCC2.y, realToBoolean1.u)
      annotation (Line(points={{293,-112},{304,-112}}, color={0,0,127}));
    connect(booleanToReal3.y, oveCC3.u)
      annotation (Line(points={{261,-288},{272,-288}}, color={0,0,127}));
    connect(oveCC3.y, realToBoolean2.u)
      annotation (Line(points={{295,-288},{306,-288}}, color={0,0,127}));
    connect(booleanToReal4.y, oveCC4.u)
      annotation (Line(points={{261,-444},{272,-444}}, color={0,0,127}));
    connect(oveCC4.y, realToBoolean3.u)
      annotation (Line(points={{295,-444},{306,-444}}, color={0,0,127}));
    connect(booleanToReal5.y, oveCC5.u)
      annotation (Line(points={{263,-602},{274,-602}}, color={0,0,127}));
    connect(oveCC5.y, realToBoolean4.u)
      annotation (Line(points={{297,-602},{308,-602}}, color={0,0,127}));
    connect(cAVControlv2_2.CC_OnOff, booleanToReal2.u) annotation (Line(points={{
            -22.7367,-149.317},{-22.7367,-112},{236,-112}},  color={255,0,255}));
    connect(realToBoolean1.y, system3CAV1.CoolingCoil_OnOff_Command)
      annotation (Line(points={{327,-112},{392,-112},{392,-266},{14,-266},{14,
            -170},{-28.322,-170},{-28.322,-177.036}},
                                                color={255,0,255}));
    connect(cAVControlv2_2.HC_Setpoint, oveHCSet2.u) annotation (Line(points={{
            -14.4733,-149.156},{-16,-149.156},{-16,-120},{220,-120},{220,-138},
            {270,-138}},
          color={0,0,127}));
    connect(oveHCSet2.y, system3CAV1.T_HeatingCoil_Command) annotation (Line(
          points={{293,-138},{384,-138},{384,-260},{18,-260},{18,-166},{-20.561,
            -166},{-20.561,-176.8}}, color={0,0,127}));
    connect(cAVControlv2_2.Damper_Setting, oveDSet2.u) annotation (Line(points={{
            -7.44333,-148.994},{-7.44333,-128},{216,-128},{216,-164},{270,-164}},
          color={0,0,127}));
    connect(oveDSet2.y, system3CAV1.OA_Damper_mixing_command) annotation (Line(
          points={{293,-164},{376,-164},{376,-254},{24,-254},{24,-160},{
            -13.8829,-160},{-13.8829,-176.8}},
                                      color={0,0,127}));
    connect(cAVControlv2_2.VFR_setting, oveVFRSet2.u) annotation (Line(points={{1.19,
            -148.672},{1.19,-136},{212,-136},{212,-190},{270,-190}},      color=
           {0,0,127}));
    connect(oveVFRSet2.y, system3CAV1.Fan_Flowrate_setpoint) annotation (Line(
          points={{293,-190},{370,-190},{370,-248},{28,-248},{28,-156},{-3.59512,
            -156},{-3.59512,-176.8}}, color={0,0,127}));
    connect(zon1.TAir, senTRoom2.u) annotation (Line(points={{139,-170.2},{206,-170.2},
            {206,-216},{270,-216}}, color={0,0,127}));
    connect(senTRoom2.y, cAVControlv2_2.T_return) annotation (Line(points={{293,
            -216},{314,-216},{314,-242},{56,-242},{56,-149.478},{-69.2333,
            -149.478}},
          color={0,0,127}));
    connect(cAVControlv2_3.CC_OnOff, booleanToReal3.u) annotation (Line(points={{
            -24.7367,-317.317},{-24.7367,-278},{216,-278},{216,-288},{238,-288}},
          color={255,0,255}));
    connect(cAVControlv2_3.HC_Setpoint, oveHCSet3.u) annotation (Line(points={{
            -16.4733,-317.156},{-16.4733,-282},{212,-282},{212,-314},{272,-314}},
                                                                         color={
            0,0,127}));
    connect(cAVControlv2_3.Damper_Setting, oveDSet3.u) annotation (Line(points={{
            -9.44333,-316.994},{-9.44333,-288},{208,-288},{208,-340},{272,-340}},
          color={0,0,127}));
    connect(cAVControlv2_3.VFR_setting, oveVFRSet3.u) annotation (Line(points={{-0.81,
            -316.672},{-0.81,-294},{202,-294},{202,-366},{272,-366}},
          color={0,0,127}));
    connect(zon2.TAir, senTRoom3.u) annotation (Line(points={{139,-304.2},{139,-304},
            {194,-304},{194,-392},{272,-392}}, color={0,0,127}));
    connect(realToBoolean2.y, system3CAV2.CoolingCoil_OnOff_Command)
      annotation (Line(points={{329,-288},{378,-288},{378,-426},{12,-426},{12,
            -334},{-30.322,-334},{-30.322,-345.036}},
                                                color={255,0,255}));
    connect(oveHCSet3.y, system3CAV2.T_HeatingCoil_Command) annotation (Line(
          points={{295,-314},{372,-314},{372,-422},{16,-422},{16,-330},{-22.561,
            -330},{-22.561,-344.8}}, color={0,0,127}));
    connect(oveDSet3.y, system3CAV2.OA_Damper_mixing_command) annotation (Line(
          points={{295,-340},{366,-340},{366,-418},{22,-418},{22,-326},{
            -15.8829,-326},{-15.8829,-344.8}},
                                      color={0,0,127}));
    connect(oveVFRSet3.y, system3CAV2.Fan_Flowrate_setpoint) annotation (Line(
          points={{295,-366},{360,-366},{360,-414},{30,-414},{30,-324},{-5.59512,
            -324},{-5.59512,-344.8}}, color={0,0,127}));
    connect(senTRoom3.y, cAVControlv2_3.T_return) annotation (Line(points={{295,
            -392},{354,-392},{354,-408},{34,-408},{34,-324},{-71.2333,-324},{
            -71.2333,-317.478}},
                        color={0,0,127}));
    connect(cAVControlv2_4.CC_OnOff, booleanToReal4.u) annotation (Line(points={{
            -26.7367,-483.317},{-26.7367,-432},{218,-432},{218,-444},{238,-444}},
          color={255,0,255}));
    connect(cAVControlv2_4.HC_Setpoint, oveHCSet4.u) annotation (Line(points={{
            -18.4733,-483.156},{-18.4733,-436},{212,-436},{212,-470},{272,-470}},
                                                                         color={
            0,0,127}));
    connect(cAVControlv2_4.Damper_Setting, oveDSet4.u) annotation (Line(points={{
            -11.4433,-482.994},{-11.4433,-442},{206,-442},{206,-496},{272,-496}},
          color={0,0,127}));
    connect(cAVControlv2_4.VFR_setting, oveVFRSet4.u) annotation (Line(points={{-2.81,
            -482.672},{-2.81,-450},{200,-450},{200,-522},{272,-522}},
          color={0,0,127}));
    connect(zon3.TAir, senTRoom4.u) annotation (Line(points={{141,-474.2},{194,-474.2},
            {194,-548},{272,-548}}, color={0,0,127}));
    connect(realToBoolean3.y, system3CAV3.CoolingCoil_OnOff_Command)
      annotation (Line(points={{329,-444},{376,-444},{376,-584},{10,-584},{10,
            -504},{-32.322,-504},{-32.322,-511.036}},
                                                color={255,0,255}));
    connect(oveHCSet4.y, system3CAV3.T_HeatingCoil_Command) annotation (Line(
          points={{295,-470},{370,-470},{370,-580},{14,-580},{14,-502},{-24.561,
            -502},{-24.561,-510.8}}, color={0,0,127}));
    connect(oveDSet4.y, system3CAV3.OA_Damper_mixing_command) annotation (Line(
          points={{295,-496},{366,-496},{366,-576},{20,-576},{20,-498},{
            -17.8829,-498},{-17.8829,-510.8}},
                                      color={0,0,127}));
    connect(oveVFRSet4.y, system3CAV3.Fan_Flowrate_setpoint) annotation (Line(
          points={{295,-522},{358,-522},{358,-572},{26,-572},{26,-494},{-7.59512,
            -494},{-7.59512,-510.8}}, color={0,0,127}));
    connect(senTRoom4.y, cAVControlv2_4.T_return) annotation (Line(points={{295,
            -548},{352,-548},{352,-568},{30,-568},{30,-490},{-73.2333,-490},{
            -73.2333,-483.478}},
                        color={0,0,127}));
    connect(cAVControlv2_5.CC_OnOff, booleanToReal5.u) annotation (Line(points={{
            -32.7367,-645.317},{-32.7367,-590},{220,-590},{220,-602},{240,-602}},
          color={255,0,255}));
    connect(cAVControlv2_5.HC_Setpoint, oveHCSet5.u) annotation (Line(points={{
            -24.4733,-645.156},{-24.4733,-596},{216,-596},{216,-628},{274,-628}},
                                                                         color={
            0,0,127}));
    connect(cAVControlv2_5.Damper_Setting, oveDSet5.u) annotation (Line(points={{
            -17.4433,-644.994},{-17.4433,-604},{208,-604},{208,-654},{274,-654}},
          color={0,0,127}));
    connect(cAVControlv2_5.VFR_setting, oveVFRSet5.u) annotation (Line(points={{-8.81,
            -644.672},{-8.81,-612},{200,-612},{200,-680},{274,-680}},
          color={0,0,127}));
    connect(zon4.TAir, senTRoom5.u) annotation (Line(points={{139,-636.2},{196,-636.2},
            {196,-706},{274,-706}}, color={0,0,127}));
    connect(realToBoolean4.y, system3CAV4.CoolingCoil_OnOff_Command)
      annotation (Line(points={{331,-602},{370,-602},{370,-766},{8,-766},{8,
            -664},{-38.322,-664},{-38.322,-673.036}},
                                                color={255,0,255}));
    connect(oveHCSet5.y, system3CAV4.T_HeatingCoil_Command) annotation (Line(
          points={{297,-628},{364,-628},{364,-760},{14,-760},{14,-660},{-30.561,
            -660},{-30.561,-672.8}}, color={0,0,127}));
    connect(oveDSet5.y, system3CAV4.OA_Damper_mixing_command) annotation (Line(
          points={{297,-654},{356,-654},{356,-754},{22,-754},{22,-656},{
            -23.8829,-656},{-23.8829,-672.8}},
                                      color={0,0,127}));
    connect(oveVFRSet5.y, system3CAV4.Fan_Flowrate_setpoint) annotation (Line(
          points={{297,-680},{350,-680},{350,-748},{26,-748},{26,-652},{
            -13.5951,-652},{-13.5951,-672.8}},
                                      color={0,0,127}));
    connect(senTRoom5.y, cAVControlv2_5.T_return) annotation (Line(points={{297,
            -706},{344,-706},{344,-744},{34,-744},{34,-636},{-90,-636},{-90,
            -645.478},{-79.2333,-645.478}},
                                  color={0,0,127}));
    connect(system3CAV.HVAC_Tot_H_Power, multiSum.u[1]) annotation (Line(points={{9.24878,
            -15.0364},{370,-15.0364},{370,-78.64},{432,-78.64}},          color=
           {0,0,127}));
    connect(system3CAV2.HVAC_Tot_H_Power, multiSum.u[2]) annotation (Line(
          points={{3.24878,-345.036},{382,-345.036},{382,-80.32},{432,-80.32}},
          color={0,0,127}));
    connect(multiSum.u[3], system3CAV3.HVAC_Tot_H_Power) annotation (Line(
          points={{432,-82},{382,-82},{382,-512},{1.24878,-512},{1.24878,
            -511.036}},
          color={0,0,127}));
    connect(multiSum.u[4], system3CAV4.HVAC_Tot_H_Power) annotation (Line(
          points={{432,-83.68},{432,-728},{66,-728},{66,-673.036},{-4.75122,
            -673.036}},
          color={0,0,127}));
    connect(multiSum.y, senHPow.u) annotation (Line(points={{445.02,-82},{438,-82},
            {438,-58},{458,-58}}, color={0,0,127}));

    connect(system3CAV1.HVAC_Tot_H_Power, multiSum.u[5]) annotation (Line(
          points={{5.24878,-177.036},{218.624,-177.036},{218.624,-85.36},{432,
            -85.36}},
          color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
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

  // Heating coils
  Modelica.Blocks.Interfaces.RealInput oveHCSet1_u(
    unit="1",
    min=0,
    max=1) "Heating Coil Setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet1_activate
    "Activation for Heating Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet2_u(
    unit="1",
    min=0,
    max=1) "Heating Coil Setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet2_activate
    "Activation for Heating Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet3_u(
    unit="1",
    min=0,
    max=1) "Heating Coil Setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet3_activate
    "Activation for Heating Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet4_u(
    unit="1",
    min=0,
    max=1) "Heating Coil Setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet4_activate
    "Activation for Heating Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveHCSet5_u(
    unit="1",
    min=0,
    max=1) "Heating Coil Setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveHCSet5_activate
    "Activation for Heating Coil Setpoint";

  // Cooling coils

  Modelica.Blocks.Interfaces.RealInput oveCC1_u(
    unit="1",
    min=0,
    max=1) "Cooling Coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC1_activate
    "Activation for Cooling Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC2_u(
    unit="1",
    min=0,
    max=1) "Cooling Coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC2_activate
    "Activation for Cooling Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC3_u(
    unit="1",
    min=0,
    max=1) "Cooling Coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC3_activate
    "Activation for Cooling Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC4_u(
    unit="1",
    min=0,
    max=1) "Cooling Coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC4_activate
    "Activation for Cooling Coil Setpoint";

  Modelica.Blocks.Interfaces.RealInput oveCC5_u(
    unit="1",
    min=0,
    max=1) "Cooling Coil On/Off (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveCC5_activate
    "Activation for Cooling Coil Setpoint";

  // OA damper settings

  Modelica.Blocks.Interfaces.RealInput oveDSet1_u(
    unit="1",
    min=0,
    max=1) "OA Damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet1_activate
    "Activation for OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet2_u(
    unit="1",
    min=0,
    max=1) "OA Damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet2_activate
    "Activation for OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet3_u(
    unit="1",
    min=0,
    max=1) "OA Damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet3_activate
    "Activation for OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet4_u(
    unit="1",
    min=0,
    max=1) "OA Damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet4_activate
    "Activation for OA damper setpoint";

  Modelica.Blocks.Interfaces.RealInput oveDSet5_u(
    unit="1",
    min=0,
    max=1) "OA Damper setpoint (0-1)";
  Modelica.Blocks.Interfaces.BooleanInput oveDSet5_activate
    "Activation for OA damper setpoint";

  // Fan On/Off signals

  Modelica.Blocks.Interfaces.RealInput oveVFRSet1_u(
    unit="1",
    min=0,
    max=100) "Fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet1_activate
    "Activation for Fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet2_u(
    unit="1",
    min=0,
    max=100) "Fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet2_activate
    "Activation for Fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet3_u(
    unit="1",
    min=0,
    max=100) "Fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet3_activate
    "Activation for Fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet4_u(
    unit="1",
    min=0,
    max=100) "Fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet4_activate
    "Activation for Fan VFR setpoint";

  Modelica.Blocks.Interfaces.RealInput oveVFRSet5_u(
    unit="1",
    min=0,
    max=100) "Fan VFR setpoint";
  Modelica.Blocks.Interfaces.BooleanInput oveVFRSet5_activate
    "Activation for Fan VFR setpoint";


  /////////////
  // OUTPUTS //
  /////////////

  Modelica.Blocks.Interfaces.RealOutput senTRoom1_y(unit="K") = mod.senTRoom1.y
    "Core Room Temperature";
  Modelica.Blocks.Interfaces.RealOutput senTRoom2_y(unit="K") = mod.senTRoom2.y
    "P1 Room Temperature";
  Modelica.Blocks.Interfaces.RealOutput senTRoom3_y(unit="K") = mod.senTRoom3.y
    "P2 Room Temperature";
  Modelica.Blocks.Interfaces.RealOutput senTRoom4_y(unit="K") = mod.senTRoom4.y
    "P3 Room Temperature";
  Modelica.Blocks.Interfaces.RealOutput senTRoom5_y(unit="K") = mod.senTRoom5.y
    "P4 Room Temperature";

  Modelica.Blocks.Interfaces.RealOutput senHPow_y(unit="W") = mod.senHPow.y
    "Total HVAC Power demand";

  Modelica.Blocks.Interfaces.RealOutput senDay_y(unit="1") = mod.senDay.y
    "Daytime (1:True, 0:False)";

  // Original model
  SOM3 mod(
    weaDat(filNam=ModelicaServices.ExternalReferences.loadResource("modelica://som3/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    building(idfName=Modelica.Utilities.Files.loadResource("modelica://som3/RefBldgSmallOfficeNew2004_Chicago.idf"),
        weaName=Modelica.Utilities.Files.loadResource("modelica://som3/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    oveHCSet1(uExt(y=oveHCSet1_u), activate(y=oveHCSet1_activate)),
    oveHCSet2(uExt(y=oveHCSet2_u), activate(y=oveHCSet2_activate)),
    oveHCSet3(uExt(y=oveHCSet3_u), activate(y=oveHCSet3_activate)),
    oveHCSet4(uExt(y=oveHCSet4_u), activate(y=oveHCSet4_activate)),
    oveHCSet5(uExt(y=oveHCSet5_u), activate(y=oveHCSet5_activate)),
    oveCC1(uExt(y=oveCC1_u), activate(y=oveCC1_activate)),
    oveCC2(uExt(y=oveCC2_u), activate(y=oveCC2_activate)),
    oveCC3(uExt(y=oveCC3_u), activate(y=oveCC3_activate)),
    oveCC4(uExt(y=oveCC4_u), activate(y=oveCC4_activate)),
    oveCC5(uExt(y=oveCC5_u), activate(y=oveCC5_activate)),
    oveDSet1(uExt(y=oveDSet1_u), activate(y=oveDSet1_activate)),
    oveDSet2(uExt(y=oveDSet2_u), activate(y=oveDSet2_activate)),
    oveDSet3(uExt(y=oveDSet3_u), activate(y=oveDSet3_activate)),
    oveDSet4(uExt(y=oveDSet4_u), activate(y=oveDSet4_activate)),
    oveDSet5(uExt(y=oveDSet5_u), activate(y=oveDSet5_activate)),
    oveVFRSet1(uExt(y=oveVFRSet1_u), activate(y=oveVFRSet1_activate)),
    oveVFRSet2(uExt(y=oveVFRSet2_u), activate(y=oveVFRSet2_activate)),
    oveVFRSet3(uExt(y=oveVFRSet3_u), activate(y=oveVFRSet3_activate)),
    oveVFRSet4(uExt(y=oveVFRSet4_u), activate(y=oveVFRSet4_activate)),
    oveVFRSet5(uExt(y=oveVFRSet5_u), activate(y=oveVFRSet5_activate)))
    "Original model with overwrites";

  annotation (uses(Modelica(version="3.2.3")));
end wrapped;
