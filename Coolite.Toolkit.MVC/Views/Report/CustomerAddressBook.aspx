<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body  {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
        }
        
        #customers-ct table { width: 100% !important; }
        
        #customers-ct th {
            background: #F0F4F5 url(/extjs/resources/images/gray/toolbar/bg-gif/coolite.axd) repeat-x scroll left top;
            font-weight: bold;
            padding: 8px 5px;
        }
       
        #customers-ct td {
            padding: 5px;
            border-bottom: 1px solid silver;
        }
        
        #customers-ct .letter-row {
            padding-top: 15px;
            border: none;
        }
        
        #customers-ct .letter-row h2 { font-size: 2em; }
        
        #customers-ct .header { padding: 10px 0px 10px 5px; }
        
        #customers-ct .header p { font-size: 2em; }

        #customers-ct .header a { margin-bottom: 10px; }
        
        .cust-name-over {
            cursor: pointer;
            background-color: #efefef;
        }
        
        #customers-ct .letter-row div {
            border-bottom: 2px solid #99bbe8;
            cursor: pointer;
            background: transparent url(/resources/images/group-expand-sprite.gif) no-repeat 0px -39px;
            margin-bottom: 5px;
        }

        #customers-ct .letter-row div h2  { padding-left: 18px; }

        #customers-ct .letter-row div.collapsed { background-position: 0px 11px; }
        
        #customers-ct tr.collapsed { display: none; }
        
        .customer-label {
            font-weight: bold;
            font-size: 12px;
            padding: 5px 0px 5px 28px;            
            width: 150px;
        }
    </style>
    
    <script type="text/javascript">
        var viewClick = function (dv, e) {
            var group = e.getTarget('h2.letter-selector');
            if (group) {
                Ext.fly(group).up('div').toggleClass('collapsed');
                Ext.select("#customers-ct tr.l-" + group.innerHTML).toggleClass('collapsed');
            }
        }

        var nodeClick = function (view, index, node, e) {            
            var nd = Ext.fly(node).first('td');
            DataViewContextMenu.node = {
                id: nd.getAttributeNS("", "custID"),
                name: nd.getAttributeNS("", "custName"),
                contact: nd.dom.innerHTML,
                email: nd.getAttributeNS("", "email")
            };
            DataViewContextMenu.showAt(e.getXY());
        }
    </script>
</head>
<body>
    <ext:ScriptManager runat="server" />
    
    <ext:Menu ID="DataViewContextMenu" runat="server">
        <Items>
            <ext:TextMenuItem ID="CustomerLabel" runat="server" CtCls="customer-label"  />
            <ext:MenuItem runat="server" Text="Send Mail" Icon="Mail">   
                <Listeners>
                    <Click Handler="if(Ext.isEmpty(this.parentMenu.node.email, false)) { Ext.Msg.alert('Error', 'Customer has no email');} else { parent.location = 'mailto:'+this.parentMenu.node.email }" />
                </Listeners>                
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Show Details" Icon="ApplicationFormEdit">
                <Listeners>
                    <Click Handler="var win = CustomerDetailsWindow; win.autoLoad.params.id = this.parentMenu.node.id; win.setTitle(this.parentMenu.node.name); win.show();" />
                </Listeners>
            </ext:MenuItem>
        </Items>
        <Listeners>
            <BeforeShow Handler="#{CustomerLabel}.el.update(this.node.contact);" />
        </Listeners>
    </ext:Menu> 
    
    
    <ext:Store ID="dsReport" runat="server">
        <Proxy>
            <ext:HttpProxy Url="/Data/CustomerAddressBookReport/" />
        </Proxy>
        <Reader>
            <ext:JsonReader Root="data">
                <Fields>
                    <ext:RecordField Name="Letter" />
                    <ext:RecordField Name="Customers" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    
    <ext:Toolbar runat="server">
        <Items>
            <ext:Button runat="server" Text="Print" Icon="Printer">
                <Listeners>
                    <Click Handler="window.print();" />
                </Listeners>
            </ext:Button>
        </Items>
    </ext:Toolbar>
    
    <ext:DataView 
        ID="DataView1" 
        runat="server" 
        StoreID="dsReport" 
        SingleSelect="true"
        ItemSelector="tr.customer-record" 
        OverClass="cust-name-over"
        EmptyText="No customers to display">
        <Template ID="Template1" runat="server">
                <div id="customers-ct">
                    <div class="header">
                        <p>Customer Address Book</p>                                                                        
                    </div>
                    <table>
                        <tr>
                            <th>Contact Name</th>
                            <th>Address</th>
                            <th>City</th>
                            <th>State/Province</th>
                            <th>Zip/Postal Code</th>
                            <th>Country/Region</th>
                        </tr>
                    
                        <tpl for=".">
                                <tr>
                                    <td class="letter-row" colspan="6">
                                        <div><h2 class="letter-selector">{Letter}</h2></div>
                                    </td>
                                </tr>
                                <tpl for="Customers">
                                    <tr class="customer-record l-{parent.Letter}">
                                        <td class="cust-name" custID="{CustomerID}" custName="{CompanyName}" email="{Email}">{ContactName}</td>
                                        <td>&nbsp;{Address}</td>
                                        <td>&nbsp;{City}</td>
                                        <td>&nbsp;{Region}</td>
                                        <td>&nbsp;{PostalCode}</td>
                                        <td>&nbsp;{Country}</td>
                                    </tr>
                                </tpl>
                        </tpl>                    
                    </table>
                </div>
        </Template>
        <Listeners>
            <ContainerClick Fn="viewClick" />
            <Click Fn="nodeClick" />
        </Listeners>
    </ext:DataView>
    
     <ext:Window 
        ID="CustomerDetailsWindow" 
        runat="server" 
        Icon="ApplicationFormEdit" 
        Width="800" 
        Height="600" 
        ShowOnLoad="false" 
        Modal="true"
        Constrain="true">
        <AutoLoad 
            Url="/Customer/CustomerDetails/" 
            Mode="IFrame" 
            TriggerEvent="show" 
            ReloadOnEvent="true" 
            ShowMask="true" 
            MaskMsg="Loading customer...">
            <Params>
                <ext:Parameter Name="id" Value="" Mode="Value" />
            </Params>
        </AutoLoad>
        <Buttons>
            <ext:Button runat="server" ID="btnDetailsCancel" Text="Close">
                <Listeners>
                    <Click Handler="#{CustomerDetailsWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <Hide Handler="if(this.iframe.dom.contentWindow.customerChanged) { dsReport.reload(); };" />
        </Listeners>
    </ext:Window>
</body>
</html>
