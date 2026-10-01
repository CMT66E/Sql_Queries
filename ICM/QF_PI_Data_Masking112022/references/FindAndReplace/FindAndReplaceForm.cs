using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;

namespace FindAndReplace
{
    public partial class FindAndReplaceForm : Form
    {
        // make the regex and match class level variables
        // to make happen find next
        private Regex regex;
        private Match match;

        // variable to indicate finding first time 
        // or is it a find next
        private bool isFirstFind = true;

        public FindAndReplaceForm()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Click event handler of find button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void findButton_Click(object sender, EventArgs e)
        {
            FindText();
        }

        /// <summary>
        /// finds the text in searchTextBox in contentTextBox
        /// </summary>
        private void FindText()
        {
            // Is this the first time find is called?
            // Then make instances of RegEx and Match
            if (isFirstFind)
            {
                regex = GetRegExpression();
                match = regex.Match(contentTextBox.Text);
                isFirstFind = false;
            }
            else
            {
                // match.NextMatch() is also ok, except in Replace
                // In replace as text is changing, it is necessary to
                // find again
                //match = match.NextMatch();
                match = regex.Match(contentTextBox.Text, match.Index + 1);
            }

            // found a match?
            if (match.Success)
            {
                // then select it
                contentTextBox.SelectionStart = match.Index;
                contentTextBox.SelectionLength = match.Length;
            }
            else // didn't find? bad luck.
            {
                MessageBox.Show(String.Format("Cannot find '{0}'.   ", searchTextBox.Text),
                        Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                isFirstFind = true;
            }
        }

        /// <summary>
        /// This function makes and returns a RegEx object
        /// depending on user input
        /// </summary>
        /// <returns></returns>
        private Regex GetRegExpression()
        {
            Regex result;
            String regExString;
            
            // Get what the user entered
            regExString = searchTextBox.Text;

            if (useRegulatExpressionCheckBox.Checked)
            {
                // If regular expressions checkbox is selected,
                // our job is easy. Just do nothing
            }
            // wild cards checkbox checked
            else if (useWildcardsCheckBox.Checked)
            {
                regExString = regExString.Replace("*", @"\w*");     // multiple characters wildcard (*)
                regExString = regExString.Replace("?", @"\w");      // single character wildcard (?)

                // if wild cards selected, find whole words only
                regExString = String.Format("{0}{1}{0}",  @"\b", regExString);
            }
            else
            {
                // replace escape characters
                regExString = Regex.Escape(regExString);
            }

            // Is whole word check box checked?
            if (matchWholeWordCheckBox.Checked)
            {
                regExString = String.Format("{0}{1}{0}",  @"\b", regExString);
            }

            // Is match case checkbox checked?
            if (matchCaseCheckBox.Checked)
            {
                result = new Regex(regExString);
            }
            else
            {
                result = new Regex(regExString, RegexOptions.IgnoreCase);
            }

            return result;
        }

        /// <summary>
        /// TextChanged event handler of searchTextBox
        /// Set isFirstFind to true, if text changes
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            isFirstFind = true;
        }

        /// <summary>
        /// CheckedChanged event handler of matchWholeWordCheckBox
        /// Set isFirstFind to true, if check box is checked or unchecked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void matchWholeWordCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            isFirstFind = true;
        }

        /// <summary>
        /// CheckedChanged event handler of matchCaseCheckBox
        /// Set isFirstFind to true, if check box is checked or unchecked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void matchCaseCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            isFirstFind = true;
        }

        /// <summary>
        /// CheckedChanged event handler of useWildcardsCheckBox
        /// Set isFirstFind to true, if check box is checked or unchecked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void useWildcardsCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            isFirstFind = true;
        }


        /// <summary>
        /// Click event handler of replaceButton
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void replaceButton_Click(object sender, EventArgs e)
        {
            // Make a local RegEx and Match instances
            Regex regexTemp = GetRegExpression();
            Match matchTemp = regexTemp.Match(contentTextBox.SelectedText);

            if (matchTemp.Success)
            {
                // check if it is an exact match
                if (matchTemp.Value == contentTextBox.SelectedText)
                {
                    contentTextBox.SelectedText = replaceTextBox.Text;
                }
            }
            
            FindText();
        }

        /// <summary>
        /// Click event handler of replaceAllButton
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void replaceAllButton_Click(object sender, EventArgs e)
        {
            Regex replaceRegex = GetRegExpression();
            String replacedString;

            // get the current SelectionStart
            int selectedPos = contentTextBox.SelectionStart;

            // get the replaced string
            replacedString = replaceRegex.Replace(contentTextBox.Text, replaceTextBox.Text);

            // Is the text changed?
            if (contentTextBox.Text != replacedString)
            {
                // then replace it
                contentTextBox.Text = replacedString;
                MessageBox.Show("Replacements are made.   ", Application.ProductName,
                    MessageBoxButtons.OK, MessageBoxIcon.Information);

                // restore the SelectionStart
                contentTextBox.SelectionStart = selectedPos;
            }
            else // inform user if no replacements are made
            {
                MessageBox.Show(String.Format("Cannot find '{0}'.   ", searchTextBox.Text),
                    Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Information);
            }

            contentTextBox.Focus();
        }

        private void FindAndReplaceForm_Load(object sender, EventArgs e)
        {
            
        }
    }
}