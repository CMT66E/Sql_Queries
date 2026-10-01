namespace FindAndReplace
{
    partial class FindAndReplaceForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FindAndReplaceForm));
            this.contentTextBox = new System.Windows.Forms.TextBox();
            this.searchTextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.findButton = new System.Windows.Forms.Button();
            this.matchWholeWordCheckBox = new System.Windows.Forms.CheckBox();
            this.matchCaseCheckBox = new System.Windows.Forms.CheckBox();
            this.replaceButton = new System.Windows.Forms.Button();
            this.replaceTextBox = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.replaceAllButton = new System.Windows.Forms.Button();
            this.useWildcardsCheckBox = new System.Windows.Forms.CheckBox();
            this.useRegulatExpressionCheckBox = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // contentTextBox
            // 
            this.contentTextBox.HideSelection = false;
            this.contentTextBox.Location = new System.Drawing.Point(12, 12);
            this.contentTextBox.Multiline = true;
            this.contentTextBox.Name = "contentTextBox";
            this.contentTextBox.Size = new System.Drawing.Size(544, 243);
            this.contentTextBox.TabIndex = 0;
            this.contentTextBox.Text = resources.GetString("contentTextBox.Text");
            // 
            // searchTextBox
            // 
            this.searchTextBox.Location = new System.Drawing.Point(106, 270);
            this.searchTextBox.Name = "searchTextBox";
            this.searchTextBox.Size = new System.Drawing.Size(213, 20);
            this.searchTextBox.TabIndex = 2;
            this.searchTextBox.TextChanged += new System.EventHandler(this.searchTextBox_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(48, 277);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(41, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Search";
            // 
            // findButton
            // 
            this.findButton.Location = new System.Drawing.Point(266, 437);
            this.findButton.Name = "findButton";
            this.findButton.Size = new System.Drawing.Size(88, 29);
            this.findButton.TabIndex = 8;
            this.findButton.Text = "Find";
            this.findButton.UseVisualStyleBackColor = true;
            this.findButton.Click += new System.EventHandler(this.findButton_Click);
            // 
            // matchWholeWordCheckBox
            // 
            this.matchWholeWordCheckBox.AutoSize = true;
            this.matchWholeWordCheckBox.Location = new System.Drawing.Point(106, 332);
            this.matchWholeWordCheckBox.Name = "matchWholeWordCheckBox";
            this.matchWholeWordCheckBox.Size = new System.Drawing.Size(113, 17);
            this.matchWholeWordCheckBox.TabIndex = 5;
            this.matchWholeWordCheckBox.Text = "Match whole word";
            this.matchWholeWordCheckBox.UseVisualStyleBackColor = true;
            this.matchWholeWordCheckBox.CheckedChanged += new System.EventHandler(this.matchWholeWordCheckBox_CheckedChanged);
            // 
            // matchCaseCheckBox
            // 
            this.matchCaseCheckBox.AutoSize = true;
            this.matchCaseCheckBox.Location = new System.Drawing.Point(106, 355);
            this.matchCaseCheckBox.Name = "matchCaseCheckBox";
            this.matchCaseCheckBox.Size = new System.Drawing.Size(82, 17);
            this.matchCaseCheckBox.TabIndex = 6;
            this.matchCaseCheckBox.Text = "Match case";
            this.matchCaseCheckBox.UseVisualStyleBackColor = true;
            this.matchCaseCheckBox.CheckedChanged += new System.EventHandler(this.matchCaseCheckBox_CheckedChanged);
            // 
            // replaceButton
            // 
            this.replaceButton.Location = new System.Drawing.Point(360, 437);
            this.replaceButton.Name = "replaceButton";
            this.replaceButton.Size = new System.Drawing.Size(88, 29);
            this.replaceButton.TabIndex = 9;
            this.replaceButton.Text = "Replace";
            this.replaceButton.UseVisualStyleBackColor = true;
            this.replaceButton.Click += new System.EventHandler(this.replaceButton_Click);
            // 
            // replaceTextBox
            // 
            this.replaceTextBox.Location = new System.Drawing.Point(106, 303);
            this.replaceTextBox.Name = "replaceTextBox";
            this.replaceTextBox.Size = new System.Drawing.Size(213, 20);
            this.replaceTextBox.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(17, 306);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(72, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Replace with:";
            // 
            // replaceAllButton
            // 
            this.replaceAllButton.Location = new System.Drawing.Point(454, 437);
            this.replaceAllButton.Name = "replaceAllButton";
            this.replaceAllButton.Size = new System.Drawing.Size(88, 29);
            this.replaceAllButton.TabIndex = 10;
            this.replaceAllButton.Text = "Replace All";
            this.replaceAllButton.UseVisualStyleBackColor = true;
            this.replaceAllButton.Click += new System.EventHandler(this.replaceAllButton_Click);
            // 
            // useWildcardsCheckBox
            // 
            this.useWildcardsCheckBox.AutoSize = true;
            this.useWildcardsCheckBox.Location = new System.Drawing.Point(106, 377);
            this.useWildcardsCheckBox.Name = "useWildcardsCheckBox";
            this.useWildcardsCheckBox.Size = new System.Drawing.Size(95, 17);
            this.useWildcardsCheckBox.TabIndex = 7;
            this.useWildcardsCheckBox.Text = "Use wildcards ";
            this.useWildcardsCheckBox.UseVisualStyleBackColor = true;
            this.useWildcardsCheckBox.CheckedChanged += new System.EventHandler(this.useWildcardsCheckBox_CheckedChanged);
            // 
            // useRegulatExpressionCheckBox
            // 
            this.useRegulatExpressionCheckBox.AutoSize = true;
            this.useRegulatExpressionCheckBox.Location = new System.Drawing.Point(106, 400);
            this.useRegulatExpressionCheckBox.Name = "useRegulatExpressionCheckBox";
            this.useRegulatExpressionCheckBox.Size = new System.Drawing.Size(138, 17);
            this.useRegulatExpressionCheckBox.TabIndex = 11;
            this.useRegulatExpressionCheckBox.Text = "Use regular expressions";
            this.useRegulatExpressionCheckBox.UseVisualStyleBackColor = true;
            // 
            // FindAndReplaceForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(568, 478);
            this.Controls.Add(this.useRegulatExpressionCheckBox);
            this.Controls.Add(this.useWildcardsCheckBox);
            this.Controls.Add(this.replaceAllButton);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.replaceTextBox);
            this.Controls.Add(this.replaceButton);
            this.Controls.Add(this.matchCaseCheckBox);
            this.Controls.Add(this.matchWholeWordCheckBox);
            this.Controls.Add(this.findButton);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.searchTextBox);
            this.Controls.Add(this.contentTextBox);
            this.Name = "FindAndReplaceForm";
            this.Text = "FindAndReplaceForm";
            this.Load += new System.EventHandler(this.FindAndReplaceForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox contentTextBox;
        private System.Windows.Forms.TextBox searchTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button findButton;
        private System.Windows.Forms.CheckBox matchWholeWordCheckBox;
        private System.Windows.Forms.CheckBox matchCaseCheckBox;
        private System.Windows.Forms.Button replaceButton;
        private System.Windows.Forms.TextBox replaceTextBox;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button replaceAllButton;
        private System.Windows.Forms.CheckBox useWildcardsCheckBox;
        private System.Windows.Forms.CheckBox useRegulatExpressionCheckBox;
    }
}

