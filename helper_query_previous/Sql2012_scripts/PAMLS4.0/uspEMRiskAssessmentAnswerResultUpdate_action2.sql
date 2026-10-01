	declare @InstrumentID int
	set @InstrumentID = 4000005
	
	declare @SystemUserId int
	set @SystemUserId = 1266
	
	declare @DataRiskEMAssessment XML
	set @DataRiskEMAssessment = '
<DataRiskEMAssessment>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>1</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>2</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>3</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>3</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>4</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>4</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>5</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>5</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>6</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>6</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>3</EMAssessmentSectionID>
    <EMAssessmentSection>Penalty Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>3</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>7</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>3</EMAssessmentSectionID>
    <EMAssessmentSection>Penalty Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>3</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>8</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>3</EMAssessmentSectionID>
    <EMAssessmentSection>Penalty Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>3</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>9</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>10</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago? (2012)</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>11</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago? (2011)</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>12</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago? (2010)</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>13</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>14</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>15</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>16</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>17</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>18</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>19</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>20</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>21</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>8</EMAssessmentSectionID>
    <EMAssessmentSection>Mandatory environmental audits</EMAssessmentSection>
    <EMAssessmentQuestionID>8</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>22</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>8</EMAssessmentSectionID>
    <EMAssessmentSection>Mandatory environmental audits</EMAssessmentSection>
    <EMAssessmentQuestionID>8</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>23</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>8</EMAssessmentSectionID>
    <EMAssessmentSection>Mandatory environmental audits</EMAssessmentSection>
    <EMAssessmentQuestionID>8</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>24</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>9</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>25</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Reactive?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>9</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>26</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>10</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>27</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Reactive?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>10</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>28</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>11</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>29</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Reactive?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>11</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>30</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>12</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>31</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Incident related?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>12</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>32</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>12</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>33</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>34</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Incident related?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>35</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>36</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>14</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>37</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Incident related?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>14</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>38</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>14</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>39</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>3</EMAssessmentCategoryID>
    <EMAssessmentSectionID>11</EMAssessmentSectionID>
    <EMAssessmentSection>Annual return non-compliances</EMAssessmentSection>
    <EMAssessmentQuestionID>15</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>56</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Number of Annual Return non-compliances in the past 12 months?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>16</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>40</EMAssessmentAnswerID>
    <EMAssessmentAnswer>No</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>20</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>49</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>21</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>50</EMAssessmentAnswerID>
    <EMAssessmentAnswer>No</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>22</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>52</EMAssessmentAnswerID>
    <EMAssessmentAnswer>No</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>23</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>54</EMAssessmentAnswerID>
    <EMAssessmentAnswer>No</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>17</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>-1</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-1</EnteredValue>
  </viewEMAssessmentResult>
</DataRiskEMAssessment>
'

--if (CHARINDEX('xmlns', cast(@DataRiskEMAssessment as varchar(MAX))) >= 0)
--    set @DataRiskEMAssessment = cast([dbo].[ufn_RemoveXmlDataSetExtraText] (cast(@DataRiskEMAssessment as varchar(MAX))) as XML)
    
--print '@DataRiskEMAssessment=' + cast(@DataRiskEMAssessment as varchar(MAX))
    
 Declare 
	  
	  @EMAssessmentCategoryID int, 
	  @EMAssessmentSectionID int, 
	  @EMAssessmentSection varchar(500),
	  @EMAssessmentAnswerID int,
	  @EMAssessmentAnswer varchar(500),
	  @EnteredValue int,
	  @EMAssessmentQuestionID int;		     

 Select		            
		@InstrumentID             = xmlVals.rowvals.value('InstrumentID[1]','int'), 
		@EMAssessmentCategoryID   = xmlVals.rowvals.value('EMAssessmentCategoryID[1]','int'),
		@EMAssessmentSectionID    = xmlVals.rowvals.value('EMAssessmentSectionID[1]','int'),
		@EMAssessmentSection      = xmlVals.rowvals.value('EMAssessmentSection[1]','varchar(500)'),
		@EMAssessmentAnswerID     = xmlVals.rowvals.value('EMAssessmentAnswerID[1]','int'),
		@EMAssessmentAnswer       = xmlVals.rowvals.value('EMAssessmentAnswer[1]','varchar(500)'),
		@EnteredValue             = xmlVals.rowvals.value('EnteredValue[1]','int'), 
		@EMAssessmentQuestionID   = xmlVals.rowvals.value('EMAssessmentQuestionID[1]','int') 
 From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)
 
print '@InstrumentID=' + cast(@InstrumentID as varchar)
print '@EMAssessmentCategoryID=' + cast(@EMAssessmentCategoryID as varchar)
print '@EMAssessmentSectionID=' + cast(@EMAssessmentSectionID as varchar)
print '@EMAssessmentSection=' + cast(@EMAssessmentSection as varchar)
print '@EMAssessmentAnswerID=' + cast(@EMAssessmentAnswerID as varchar)

 --SELECT A.* 	        
 --FROM tblEMAssessmentResultAnswer A   
 --INNER JOIN tblEMAssessmentResultSection B
 --ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
 --INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
 --WHERE C.InstrumentID = @InstrumentID 

 --SELECT xmlR.* 		        
 --FROM  
	--		(
	--			SELECT					
	--				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 
	--				xmlVals.rowvals.query('EMAssessmentCategoryID').value('.','int') EMAssessmentCategoryID, 	
	--				xmlVals.rowvals.query('EMAssessmentSectionID').value('.','int') EMAssessmentSectionID,	
	--				xmlVals.rowvals.query('EMAssessmentSection').value('.','varchar(255)') EMAssessmentSection,				
	--				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 	
	--				xmlVals.rowvals.query('EMAssessmentAnswer').value('.','varchar(255)') EMAssessmentAnswer,			   				 				
	--				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue,
	--				xmlVals.rowvals.query('EMAssessmentQuestionID').value('.','int') EMAssessmentQuestionID								 
	--			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
	--		) xmlR
 --WHERE xmlR.InstrumentID = @InstrumentID  

 --SELECT A.*,  xmlR.* 		        
 --FROM tblEMAssessmentResultAnswer A 
 --INNER JOIN
	--		(
	--			SELECT					
	--				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 					
	--				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 						 				
	--				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue								 
	--			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
	--		) xmlR
 --ON xmlR.InstrumentID = @InstrumentID AND 
 --A.EMAssessmentAnswerID = xmlR.EMAssessmentAnswerID	
 --INNER JOIN tblEMAssessmentResultSection B
 --ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
 --INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
 --WHERE C.InstrumentID = @InstrumentID 


 --UPDATE A  
 --   SET 
	--[EnteredValue] = xmlR.EnteredValue,
	--[DateUpdated] = GETDATE()    			   
 --FROM tblEMAssessmentResultAnswer A 
 --INNER JOIN
	--		(
	--			SELECT					
	--				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 					
	--				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 						 				
	--				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue								 
	--			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
	--		) xmlR
 --ON xmlR.InstrumentID = @InstrumentID AND 
 --A.EMAssessmentAnswerID = xmlR.EMAssessmentAnswerID	 
 --INNER JOIN tblEMAssessmentResultSection B
 --ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
 --INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
 --WHERE C.InstrumentID = @InstrumentID 
 
DECLARE @tblInsertRow TABLE (
    Sno INT IDENTITY,
    InstrumentID                 INT NULL,
    EMAssessmentCategoryID       INT NULL,
    EMAssessmentSectionID        INT NULL,
    EMAssessmentSection          VARCHAR(255),
    EMAssessmentAnswerID         INT NULL,
    EMAssessmentAnswer           VARCHAR(255),
    EnteredValue                 INT NULL,
    EMAssessmentQuestionID       INT NULL
)					
INSERT INTO @tblInsertRow		
					     
SELECT xmlR.* 		        
FROM  
		(
			SELECT					
				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 
				xmlVals.rowvals.query('EMAssessmentCategoryID').value('.','int') EMAssessmentCategoryID, 	
				xmlVals.rowvals.query('EMAssessmentSectionID').value('.','int') EMAssessmentSectionID,	
				xmlVals.rowvals.query('EMAssessmentSection').value('.','varchar(255)') EMAssessmentSection,				
				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 	
				xmlVals.rowvals.query('EMAssessmentAnswer').value('.','varchar(255)') EMAssessmentAnswer,			   				 				
				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue,
				xmlVals.rowvals.query('EMAssessmentQuestionID').value('.','int') EMAssessmentQuestionID								 
			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
		) xmlR
WHERE xmlR.InstrumentID = @InstrumentID and xmlR.EMAssessmentAnswerID = -1 

select * from @tblInsertRow

 DECLARE @CntConMon int
 DECLARE @Cnt int
 SELECT @CntConMon = 0
 SELECT @CntConMon = count(Sno) from @tblInsertRow 
 
 print '@CntConMon=' + cast(@CntConMon as varchar)		     
 SET @Cnt = 1
 WHILE @Cnt <= @CntConMon
 BEGIN 
	       SELECT  		          
						@InstrumentID             = InstrumentID, 
						@EMAssessmentCategoryID   = EMAssessmentCategoryID,
						@EMAssessmentSectionID    = EMAssessmentSectionID,
						@EMAssessmentSection      = EMAssessmentSection,
						@EMAssessmentAnswerID     = EMAssessmentAnswerID,
						@EMAssessmentAnswer       = EMAssessmentAnswer,
						@EnteredValue             = EnteredValue, 
						@EMAssessmentQuestionID   = EMAssessmentQuestionID 
	      FROM @tblInsertRow WHERE Sno = @Cnt
	   
		  --here we check if this question already has a answer record or not
		  --if it does then we do not insert it anymore
		  if not exists(SELECT EMAssessmentResultAnswerID FROM tblEMAssessmentResultAnswer A 
		  INNER JOIN tblEMAssessmentResultSection B
		  ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
		  INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
		  INNER JOIN tblEMAssessmentAnswer D ON A.EMAssessmentAnswerID = D.EMAssessmentAnswerID
		  WHERE C.InstrumentID = @InstrumentID AND D.EMAssessmentQuestionID = @EMAssessmentQuestionID)
		  begin		   
			   
			   IF @EMAssessmentAnswerID = -1
			   BEGIN
				 --First we insert data into table: tblEMAssessmentResultCategory to get EMAssessmentResultCategoryID and insert instrumentID
			     
				 --we use this EMAssessmentResultSectionID to insert table: tblEMAssessmentResultAnswer
				 declare @EMAssessmentCategoryIDTemp int
			     
				 if not exists(select EMAssessmentResultCategoryID from tblEMAssessmentResultCategory 
				 where InstrumentID = @InstrumentID and EMAssessmentCategoryID = @EMAssessmentCategoryID)
				 begin
					 print '@@EMAssessmentCategoryID=' + cast(@EMAssessmentCategoryID as varchar)	
					 --insert into tblEMAssessmentResultCategory (InstrumentID, EMAssessmentCategoryID, DateCreated, CreatedBySystemUserID)
					 --values(@InstrumentID, @EMAssessmentCategoryID, GETDATE(), @SystemUserId)
				 end
				 else
				   select @EMAssessmentCategoryIDTemp = EMAssessmentResultCategoryID from tblEMAssessmentResultCategory 
				   where InstrumentID = @InstrumentID and EMAssessmentCategoryID = @EMAssessmentCategoryID
			     
				 print '@@@EMAssessmentCategoryID=' + cast(@EMAssessmentCategoryIDTemp as varchar)	
				 --then insert into table: tblEMAssessmentResultSection to get EMAssessmentResultSectionID
				 --first we get the EMAssessmentAnswerID
				 if (@EMAssessmentAnswerID = -1)
				 begin
					  SELECT @EMAssessmentAnswerID = [EMAssessmentAnswerID]
					  FROM [tblEMAssessmentAnswer]
					  WHERE [EMAssessmentQuestionID] = @EMAssessmentQuestionID and EMAssessmentAnswer = @EMAssessmentAnswer
					 
					 print '@@@@EMAssessmentAnswerID=' + cast(@EMAssessmentAnswerID as varchar)	
					 
					  declare @EMAssessmentResultSectionIDTemp int
					  SELECT @EMAssessmentResultSectionIDTemp = ISNULL(A.EMAssessmentResultSectionID, 0) 
					  FROM tblEMAssessmentResultAnswer A 
					  INNER JOIN tblEMAssessmentResultSection B  ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
					  INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
					  WHERE C.InstrumentID = @InstrumentID and C.EMAssessmentResultCategoryID = @EMAssessmentCategoryIDTemp and A.EMAssessmentAnswerID = @EMAssessmentAnswerID	
					  
					  --print '@@@@@EMAssessmentResultSectionIDTemp = ' + cast(@EMAssessmentResultSectionIDTemp as varchar)	
					  if @EMAssessmentResultSectionIDTemp is null OR @EMAssessmentResultSectionIDTemp = 0
					  begin
						 print '@@@@@EMAssessmentCategoryIDTemp = ' + cast(@EMAssessmentCategoryIDTemp as varchar)	
						 print '@@@@@@EMAssessmentSectionID = ' + cast(@EMAssessmentSectionID as varchar)	
					     
						 insert into tblEMAssessmentResultSection
						 (
						 EMAssessmentResultCategoryID,
						 EMAssessmentSectionID,
						 DateCreated,
						 CreatedBySystemUserID
						 )
						 values
						 (
						 @EMAssessmentCategoryIDTemp,
						 @EMAssessmentSectionID,
						 getdate(),
						 @SystemUserId
						 )
						 select @EMAssessmentResultSectionIDTemp = @@IDENTITY
						 --print '@@@@@EMAssessmentResultSectionIDTemp is null ' 			     	
					  end
					  
					  --finally we do insert action
						insert into tblEMAssessmentResultAnswer
						(
							EMAssessmentResultSectionID,
							EMAssessmentAnswerID,
							EnteredValue,
							ProvidedReasonID,
							DateCreated,
							CreatedBySystemUserID		    
						) 
						values
						(
						  @EMAssessmentResultSectionIDTemp,
						  @EMAssessmentAnswerID,
						  case @EnteredValue when -1 then 0 else @EnteredValue end,
						  null,
						  getdate(),
						  @SystemUserId
						)		 
				 end
			   END	   
		end	   
	   
	    SELECT @Cnt = @Cnt+1
 End
 delete @tblInsertRow					 


