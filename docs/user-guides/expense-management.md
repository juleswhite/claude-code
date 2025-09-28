# Expense Management - User Guide

> **Last Updated**: 2025-09-28
> **Difficulty**: Beginner
> **Estimated Time**: 5-10 minutes

## What is Expense Management?

The Expense Management feature is the heart of your personal finance tracker. It allows you to record, organize, and manage all your daily expenses in one place. Whether you're tracking a morning coffee or a monthly rent payment, this feature makes it simple to keep tabs on your spending habits.

## Getting Started

### Prerequisites
- Access to the ExpenseTracker application
- A modern web browser (Chrome, Firefox, Safari, Edge)
- No special permissions required

### Quick Start
![Expense Management Overview](../screenshots/expense-management-overview.png)
*Screenshot: Main expense management interface showing your expense list and summary*

1. **Access the feature**
   - Navigate to the application homepage
   - The expense list is visible right on the dashboard

2. **First-time setup**
   - No setup required - start adding expenses immediately!
   - Your data is automatically saved in your browser

## Step-by-Step Guide

### Basic Usage

#### Step 1: Adding Your First Expense
![Add Expense Form](../screenshots/expense-management-step1.png)
*Screenshot: The expense creation form with all fields visible*

1. Click the "Add Expense" button (green plus icon)
2. Fill in the expense details:
   - **Amount**: Enter the cost (e.g., 15.50)
   - **Category**: Choose from dropdown (Food, Transportation, Entertainment, Shopping, Bills, Other)
   - **Description**: Add details (e.g., "Lunch at Tony's Deli")
   - **Date**: Select when the expense occurred (defaults to today)
3. Click "Add Expense" to save

**Example**: Coffee purchase
- Amount: $4.75
- Category: Food
- Description: "Morning coffee at Starbucks"
- Date: Today's date

#### Step 2: Viewing Your Expenses
![Expense List View](../screenshots/expense-management-step2.png)
*Screenshot: List of expenses showing date, description, category, and amount*

1. Your expenses appear immediately in the main list
2. Most recent expenses are shown first
3. Each expense shows:
   - Date and description
   - Category with color coding
   - Amount in your currency
   - Edit and delete buttons

### Advanced Features

#### Feature A: Filtering and Searching
![Advanced Filtering](../screenshots/expense-management-advanced-a.png)
*Screenshot: Filter panel showing category, date range, and search options*

**When to use**: When you have many expenses and need to find specific ones quickly

**How to use**:
1. Use the search box to find expenses by description
2. Filter by category using the dropdown menu
3. Set date ranges to view expenses from specific periods
4. Combine filters for precise results

**Tips**:
- 💡 Search works on descriptions - be descriptive when adding expenses
- ⚡ Use category filters to analyze spending patterns
- ⚠️ Clear filters to see all expenses again

#### Feature B: Editing Expenses
**When to use**: When you need to correct a mistake or update details

**How to use**:
1. Find the expense in your list
2. Click the edit button (pencil icon)
3. Make your changes in the form
4. Click "Update Expense" to save

#### Feature C: Deleting Expenses
**When to use**: When you accidentally added a duplicate or incorrect expense

**How to use**:
1. Find the expense you want to remove
2. Click the delete button (trash icon)
3. Confirm deletion in the popup
4. The expense is permanently removed

## Common Use Cases

### Use Case 1: Weekly Expense Review
**Scenario**: You want to see what you spent this week

**Solution**:
1. Use the date filter to select "Last 7 days"
2. Review the list of expenses
3. Check the total at the bottom
4. Export to CSV if you need to share with someone

### Use Case 2: Category Budget Tracking
**Scenario**: You want to see how much you're spending on food

**Solution**:
1. Filter by "Food" category
2. Set date range to "This month"
3. View the filtered total
4. Compare against your food budget

### Use Case 3: Finding a Specific Purchase
**Scenario**: You need to find that restaurant expense from last month

**Solution**:
1. Use the search box and type the restaurant name
2. Or filter by "Food" category and browse by date
3. Click edit to view full details

## Troubleshooting

### Common Issues

#### Issue: My expenses disappeared
**Symptoms**: The expense list is empty or missing recent entries
**Solution**:
1. Check if any filters are active - clear all filters
2. Refresh the browser page
3. Make sure you're using the same browser where you added expenses
4. Check if browser storage was cleared

#### Issue: Can't add new expense
**Symptoms**: Add expense button doesn't work or form won't submit
**Solution**:
1. Make sure all required fields are filled
2. Check that the amount is a valid number
3. Refresh the page and try again
4. Make sure JavaScript is enabled in your browser

#### Issue: Export isn't working
**Symptoms**: CSV download doesn't start when clicking export
**Solution**:
1. Check your browser's download settings
2. Disable popup blockers for this site
3. Try right-clicking the export button and select "Save link as..."

### Getting Help
- Check the [Technical Documentation](../technical/expense-management.md) for detailed information
- Clear your browser cache if you experience persistent issues
- Use a different browser to test if issues are browser-specific

## Tips & Best Practices

### Do's ✅
- Be descriptive with expense descriptions for easy searching
- Add expenses daily to avoid forgetting them
- Use appropriate categories for better analysis
- Review your expenses weekly to stay on track
- Export data regularly as a backup

### Don'ts ❌
- Don't forget to select the correct date for past expenses
- Don't use vague descriptions like "stuff" or "things"
- Don't rely solely on browser storage - export important data
- Don't add duplicate expenses (check first)

## Keyboard Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Add New Expense | `Ctrl+N` | `Cmd+N` |
| Search Expenses | `Ctrl+F` | `Cmd+F` |
| Clear Filters | `Ctrl+R` | `Cmd+R` |
| Export Data | `Ctrl+E` | `Cmd+E` |

## FAQ

### Q: Where is my expense data stored?
**A**: Your expenses are stored locally in your browser's storage. This means your data stays private but is only available on the device and browser where you entered it.

### Q: Can I access my expenses from multiple devices?
**A**: Currently, no. Expenses are stored locally per browser. We recommend exporting your data regularly and importing it on other devices when that feature becomes available.

### Q: Is there a limit to how many expenses I can add?
**A**: Browser storage limits vary, but you can typically store thousands of expenses. If you're approaching limits, consider exporting older data and removing it from the active list.

### Q: Can I import expenses from my bank or credit card?
**A**: Currently, manual entry only. Future versions may include import capabilities from CSV files or financial institutions.

### Q: What happens if I accidentally delete an expense?
**A**: Deleted expenses cannot be recovered. Be careful when deleting, and consider exporting your data regularly as a backup.

## What's Next?

After mastering expense management, you might want to explore:
- [Analytics Dashboard](./analytics-dashboard.md) - Visualize your spending patterns
- [Export System](./export-system.md) - Advanced data export options
- [Budget Tracking](./budget-tracking.md) - Set and monitor spending limits

---

## Screenshot Checklist
*For documentation maintainers*

- [ ] `expense-management-overview.png` - Main expense interface
- [ ] `expense-management-step1.png` - Add expense form
- [ ] `expense-management-step2.png` - Expense list view
- [ ] `expense-management-advanced-a.png` - Filter and search features
- [ ] `expense-management-settings.png` - Category settings
- [ ] `expense-management-mobile.png` - Mobile responsive view

*Generated by Claude Code documentation system*