<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            IEnumerable data = this.Model as IEnumerable;

            if (!string.IsNullOrEmpty(this.Request["height"]))
            {
                Chart1.Height = int.Parse(this.Request["height"]);
            }

            if (!string.IsNullOrEmpty(this.Request["width"]))
            {
                Chart1.Width = int.Parse(this.Request["width"]);
            }

            Chart1.Series["Default"].Points.DataBind(data, "EmployeeName", "Total","");
            Chart1.Series["Default"]["PieLabelStyle"] = "Outside";    

            // Explode selected employees
            double max = 0;
            DataPoint maxPoint=null;
            foreach (DataPoint point in Chart1.Series["Default"].Points)
            {
                point["Exploded"] = "false";
                if (point.YValues[0] > max)
                {
                    max = point.YValues[0];
                    maxPoint = point;
                }
            }
            if (maxPoint != null)
            {
                maxPoint["Exploded"] = "true";
            }

            Chart1.Series[0]["PieDrawingStyle"] = "Concave";

            Chart1.Legends[0].Enabled = true;
        }
    </script>
</head>
<body style="margin:0px;padding:0px;" scroll="no">
    <asp:CHART id="Chart1" runat="server" 
        Palette="BrightPastel" 
        BackColor="WhiteSmoke" 
        Height="400px" 
        Width="800px" 
        BorderDashStyle="Solid" 
        BackSecondaryColor="White" 
        BackGradientStyle="TopBottom" 
        BorderWidth="0" 
        BorderColor="26, 59, 105" >
        <Legends>
			<asp:Legend 
			    BackColor="Transparent"
			    Docking="Right"
			    Font="Trebuchet MS, 8.25pt, style=Bold" 
			    IsTextAutoFit="False" 
			    LegendStyle="Column"
			    Name="Default" >
			</asp:Legend>
		</Legends>
		
		<Titles>
			<asp:Title 
			    ShadowColor="32, 0, 0, 0" 
			    Font="Trebuchet MS, 14.25pt, style=Bold" 
			    ShadowOffset="3" 
			    Text="Total Sales By Employee" 
			    Name="Title1" 
			    ForeColor="26, 59, 105">
			</asp:Title>
		</Titles>			
		
		<Borderskin SkinStyle="None"/>
		
		<Series>
			<asp:Series 
			    Name="Default" 
			    IsValueShownAsLabel="true"		
			    ToolTip="#VALX"
			    LabelFormat="C"
			    ChartType="Pie" 
			    BorderColor="180, 26, 59, 105" 
			    Color="220, 65, 140, 240">
			</asp:Series>
		</Series>
		
		<ChartAreas>
			<asp:ChartArea 
			    Name="ChartArea1" 
			    BorderColor="64, 64, 64, 64" 
			    BackSecondaryColor="Transparent" 
			    BackColor="Transparent" 
			    ShadowColor="Transparent" 
			    BorderWidth="0">
				
				<AxisY LineColor="64, 64, 64, 64">
					<LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
					<MajorGrid LineColor="64, 64, 64, 64" />						
				</AxisY>
				
				<AxisX LineColor="64, 64, 64, 64">
					<LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
					<MajorGrid LineColor="64, 64, 64, 64" />
				</AxisX>
			</asp:ChartArea>
		</ChartAreas>
	</asp:CHART>
</body>
</html>
