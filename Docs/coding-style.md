# Code Style Guidelines

## File Structure

- Use `main.tf` for primary resources
- Use `variables.tf` for input variables (not `variable.tf`)
- Use `outputs.tf` for output values
- Use `providers.tf` for provider configuration
- Use `locals.tf` for local values

## Naming Conventions

- Resources: `azurerm_<resource_type>_<descriptive_name>`
- Variables: snake_case with descriptive names
- Locals: snake_case, prefix with purpose (e.g., `common_tags`)
- Modules: source relative paths with `../../../Modules/`

## Variable Definitions

- Always include `type` and `description`
- Use `optional()` for nullable variables
- Provide `default` values where appropriate
- Use `map(string)` for tags, `list(string)` for arrays

## Code Formatting

- Use 2-space indentation
- Align resource arguments consistently
- Use conditional expressions with ternary operator
- Add explicit `depends_on` for module dependencies

## Provider Configuration

- Pin Terraform version in required_version block
- Use ~> for provider version constraints
- Configure subscription_id from variables
