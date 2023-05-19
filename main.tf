resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "A user ID-based request.",
        "properties" = {
            "conversationId" = {
                "description" = "the conversation ID",
                "type" = "string"
            }
        },
        "required" = [
            "conversationId"
        ],
        "title" = "UserIdRequest",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "properties" = {
            "userId" = {
                "description" = "the user ID",
                "type" = "array"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/analytics/conversations/$${input.conversationId}/details"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\n \"userId\": $${userId}\n}"
        translation_map = { 
			userId = "$..userId"
		}
    }
}