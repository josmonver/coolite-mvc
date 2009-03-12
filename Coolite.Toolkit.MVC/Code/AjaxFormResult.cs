﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Web.Mvc;
using Coolite.Utilities;
using Newtonsoft.Json;

namespace Coolite.Ext.Web.MVC
{
    public class AjaxFormResult : ActionResult
    {
        private bool success = true;

        [ClientConfig]
        [DefaultValue("")]
        public bool Success
        {
            get { return this.success; }
            set { this.success = value; }
        }

        private List<FieldError> errors;
        
        [ClientConfig(JsonMode.AlwaysArray)]
        public List<FieldError> Errors
        {
            get
            {
                if(this.errors == null)
                {
                    this.errors = new List<FieldError>();
                }

                return this.errors;
            }
        }

        private ParameterCollection extraParams;
        public ParameterCollection ExtraParams
        {
            get
            {
                if (this.extraParams == null)
                {
                    this.extraParams = new ParameterCollection();
                }

                return this.extraParams;
            }
        }

        [ClientConfig("extraParams", JsonMode.Raw)]
        [DefaultValue("")]
        protected string ExtraParamsProxy
        {
            get
            {
                if (this.ExtraParams.Count > 0)
                {
                   return ExtraParams.ToJsonObject();
                }

                return "";
            }
        }

        public override void ExecuteResult(ControllerContext context)
        {
            CompressionUtils.GZipResponse(new ClientConfig().Serialize(this));
        }
    }

    public class FieldError
    {
        public FieldError(string fieldId, string errorMessage)
        {
            if(string.IsNullOrEmpty(fieldId))
            {
                throw new ArgumentNullException("fieldId", "Field Id can't be empty");
            }

            if (string.IsNullOrEmpty(errorMessage))
            {
                throw new ArgumentNullException("errorMessage", "Error message can't be empty");
            }

            this.FieldId = fieldId;
            this.ErrorMessage = errorMessage;
        }

        [ClientConfig("id")]
        [DefaultValue("")]
        public string FieldId
        {
            get; set;
        }

        [ClientConfig("msg")]
        [DefaultValue("")]
        public string ErrorMessage
        {
            get; set;
        }
    }

    public class FieldErrors : Collection<FieldError>
    {
    }
}
