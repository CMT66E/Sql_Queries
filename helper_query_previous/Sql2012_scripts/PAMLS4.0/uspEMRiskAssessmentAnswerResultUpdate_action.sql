   declare @DataRiskEMAssessment XML
   declare @SystemUserId int
set @DataRiskEMAssessment = '<DataRiskEMAssessment>
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
    <EnteredValue>7</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>3</EMAssessmentSectionID>
    <EMAssessmentSection>Penalty Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>3</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>8</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>8</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>3</EMAssessmentSectionID>
    <EMAssessmentSection>Penalty Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>3</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>9</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>9</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>10</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago? (2012)</EMAssessmentAnswer>
    <EnteredValue>10</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>11</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago? (2011)</EMAssessmentAnswer>
    <EnteredValue>11</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>4</EMAssessmentSectionID>
    <EMAssessmentSection>Official cautions</EMAssessmentSection>
    <EMAssessmentQuestionID>4</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>12</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago? (2010)</EMAssessmentAnswer>
    <EnteredValue>12</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>13</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>13</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>14</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>14</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>5</EMAssessmentSectionID>
    <EMAssessmentSection>Formal warnings</EMAssessmentSection>
    <EMAssessmentQuestionID>5</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>15</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>15</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>16</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>17</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>6</EMAssessmentSectionID>
    <EMAssessmentSection>Clean Up Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>6</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>18</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>3</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>19</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>7</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>20</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>8</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>7</EMAssessmentSectionID>
    <EMAssessmentSection>Prevention Notices</EMAssessmentSection>
    <EMAssessmentQuestionID>7</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>21</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>9</EnteredValue>
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
    <EnteredValue>4</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>14</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>38</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
    <EnteredValue>5</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>14</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>39</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
    <EnteredValue>6</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>3</EMAssessmentCategoryID>
    <EMAssessmentSectionID>11</EMAssessmentSectionID>
    <EMAssessmentSection>Annual return non-compliances</EMAssessmentSection>
    <EMAssessmentQuestionID>15</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>56</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Number of Annual Return non-compliances in the past 12 months?</EMAssessmentAnswer>
    <EnteredValue>88</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>16</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>40</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>20</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>48</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>21</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>51</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>22</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>52</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>23</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>55</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>17</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>43</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>18</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>44</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>19</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>47</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>-2</EnteredValue>
  </viewEMAssessmentResult>
</DataRiskEMAssessment>'
set @SystemUserId = 1266

		     Declare @t TABLE (EMAssessmentResultAnswerID int); 
		      -- Updating into tblARNonCompliance --
		     Declare 
				  @InstrumentID int, 
				  @EMAssessmentCategoryID int, 
				  @EMAssessmentSectionID int, 
				  @EMAssessmentSection varchar(500),
				  @EMAssessmentAnswerID int,
				  @EMAssessmentAnswer varchar(500),
				  @EnteredValue int,
				  @EMAssessmentQuestionID int;		     


			 Select		
			     @InstrumentID = xmlVals.rowvals.value('InstrumentID[1]','int')				
			 From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)
 
print '@InstrumentID=' + cast(@InstrumentID as varchar)
 
 
--the user delete it this is for that 8 question on section 4 operator systems			 
DECLARE @tblDeleteRow TABLE (
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

INSERT INTO @tblDeleteRow							     
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
WHERE xmlR.InstrumentID = @InstrumentID and xmlR.EnteredValue = -2

select * from @tblDeleteRow

 DECLARE @CntConMon1 int
 DECLARE @Cnt1 int
 SELECT @CntConMon1 = 0
 SELECT @CntConMon1 = count(Sno) from @tblDeleteRow 
 
 	     
 SET @Cnt1 = 1
 WHILE @Cnt1 <= @CntConMon1
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
	      FROM @tblDeleteRow WHERE Sno = @Cnt1	
	      		 
		  IF @EnteredValue = -2 --delete action below
		  BEGIN
		     declare @EMAssessmentResultSectionIDTemp1 int
		     
		     select  @EMAssessmentResultSectionIDTemp1 = A.EMAssessmentResultSectionID 
		     from tblEMAssessmentResultAnswer A 
		     INNER JOIN tblEMAssessmentResultSection B
			 ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
			 INNER JOIN tblEMAssessmentResultCategory C 
			 ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
			 WHERE C.InstrumentID = @InstrumentID and A.EMAssessmentAnswerID  = @EMAssessmentAnswerID 
			 
print '@EMAssessmentResultSectionIDTemp1=' + cast(@EMAssessmentResultSectionIDTemp1 as varchar)			 
print '@InstrumentID=' + cast(@InstrumentID as varchar)	
print '@EMAssessmentAnswerID=' + cast(@EMAssessmentAnswerID as varchar)	
			 
			 if  not @EMAssessmentResultSectionIDTemp1 is null and @EMAssessmentResultSectionIDTemp1 > 0 
			 begin
			    print '@@EMAssessmentResultSectionIDTemp1=' + cast(@EMAssessmentResultSectionIDTemp1 as varchar)
			    --delete from tblEMAssessmentResultAnswer where EMAssessmentResultSectionID = @EMAssessmentResultSectionIDTemp1
			    --comment out the following as the whole 8 queations have same EMAssessmentResultSectionID
			    --delete from tblEMAssessmentResultSection where EMAssessmentResultSectionID = @EMAssessmentResultSectionIDTemp1
			 end
		  END	 
	    SELECT @Cnt1 = @Cnt1+1
 End
 delete @tblDeleteRow	 
 
             --if we can find the records in table: tblEMAssessmentResultAnswer
             --with EMAssessmentAnswerID equal to EMAssessmentAnswerID from XML dataset
             --we do update below
		  --   UPDATE A  
		  --      SET 
				--[EnteredValue] = xmlR.EnteredValue,
				--[DateUpdated] = GETDATE()    			   
   	--		 FROM tblEMAssessmentResultAnswer A 
   	--		 INNER JOIN
				--		(
				--			SELECT					
				--				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 					
				--				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 						 				
				--				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue								 
				--			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
				--		) xmlR
   	--		 ON xmlR.InstrumentID = @InstrumentID AND 
			 --A.EMAssessmentAnswerID = xmlR.EMAssessmentAnswerID	 
			 --INNER JOIN tblEMAssessmentResultSection B
			 --ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
			 --INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
			 --WHERE C.InstrumentID = @InstrumentID AND xmlR.EMAssessmentAnswerID <> -1  
			 
		  --   SELECT A.*			   
   	--		 FROM tblEMAssessmentResultAnswer A 
   	--		 INNER JOIN
				--		(
				--			SELECT					
				--				xmlVals.rowvals.query('InstrumentID').value('.','int') InstrumentID, 					
				--				xmlVals.rowvals.query('EMAssessmentAnswerID').value('.', 'int') EMAssessmentAnswerID, 						 				
				--				xmlVals.rowvals.query('EnteredValue').value('.', 'int') EnteredValue								 
				--			From @DataRiskEMAssessment.nodes('//DataRiskEMAssessment/viewEMAssessmentResult') as xmlVals(rowvals)				
				--		) xmlR
   	--		 ON xmlR.InstrumentID = @InstrumentID AND 
			 --A.EMAssessmentAnswerID = xmlR.EMAssessmentAnswerID	 
			 --INNER JOIN tblEMAssessmentResultSection B
			 --ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
			 --INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID
			 --WHERE C.InstrumentID = @InstrumentID 
			 
			 --AND xmlR.EMAssessmentAnswerID <> -1  			 
			 
			 --here we do insert action if XML dataset has more rows than those ones from table: tblEMAssessmentResultAnswer 
		     --if we detect the xmlR.EMAssessmentAnswerID = -1  then we need insert new row into table: tblEMAssessmentResultAnswer
		     --in order to achieve this we have to loop through all new records

--DECLARE @tblInsertRow TABLE (
--    Sno INT IDENTITY,
--    InstrumentID                 INT NULL,
--    EMAssessmentCategoryID       INT NULL,
--    EMAssessmentSectionID        INT NULL,
--    EMAssessmentSection          VARCHAR(255),
--    EMAssessmentAnswerID         INT NULL,
--    EMAssessmentAnswer           VARCHAR(255),
--    EnteredValue                 INT NULL,
--    EMAssessmentQuestionID       INT NULL
--)					
--INSERT INTO @tblInsertRow							     
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
--WHERE xmlR.InstrumentID = @InstrumentID and xmlR.EMAssessmentAnswerID = -1 

--select * from @tblInsertRow

 --DECLARE @CntConMon int
 --DECLARE @Cnt int
 --SELECT @CntConMon = 0
 --SELECT @CntConMon = count(Sno) from @tblInsertRow 
 
 	     
 --SET @Cnt = 1
 --WHILE @Cnt <= @CntConMon
 --BEGIN 
	--       SELECT  		          
	--					@InstrumentID             = InstrumentID, 
	--					@EMAssessmentCategoryID   = EMAssessmentCategoryID,
	--					@EMAssessmentSectionID    = EMAssessmentSectionID,
	--					@EMAssessmentSection      = EMAssessmentSection,
	--					@EMAssessmentAnswerID     = EMAssessmentAnswerID,
	--					@EMAssessmentAnswer       = EMAssessmentAnswer,
	--					@EnteredValue             = EnteredValue, 
	--					@EMAssessmentQuestionID   = EMAssessmentQuestionID 
	--      FROM @tblInsertRow WHERE Sno = @Cnt
	   
	--	  --here we check if this question already has a answer record or not
	--	  --if it does then we do not insert it anymore
	--	  if not exists(SELECT EMAssessmentResultAnswerID FROM tblEMAssessmentResultAnswer A 
	--	  INNER JOIN tblEMAssessmentResultSection B
	--	  ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
	--	  INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
	--	  INNER JOIN tblEMAssessmentAnswer D ON A.EMAssessmentAnswerID = D.EMAssessmentAnswerID
	--	  WHERE C.InstrumentID = @InstrumentID AND D.EMAssessmentQuestionID = @EMAssessmentQuestionID)
	--	  begin		   
			   
	--		   IF @EMAssessmentAnswerID = -1
	--		   BEGIN
	--			 --First we insert data into table: tblEMAssessmentResultCategory to get EMAssessmentResultCategoryID and insert instrumentID
			     
	--			 --we use this EMAssessmentResultSectionID to insert table: tblEMAssessmentResultAnswer
	--			 declare @EMAssessmentCategoryIDTemp int
			     
	--			 if not exists(select EMAssessmentResultCategoryID from tblEMAssessmentResultCategory 
	--			 where InstrumentID = @InstrumentID and EMAssessmentCategoryID = @EMAssessmentCategoryID)
	--				 begin					 	
	--					 insert into tblEMAssessmentResultCategory (InstrumentID, EMAssessmentCategoryID, DateCreated, CreatedBySystemUserID)
	--					 values(@InstrumentID, @EMAssessmentCategoryID, GETDATE(), @SystemUserId)
	--					 select @EMAssessmentCategoryIDTemp = @@IDENTITY
	--				 end
	--			 else
	--				   select @EMAssessmentCategoryIDTemp = EMAssessmentResultCategoryID from tblEMAssessmentResultCategory 
	--				   where InstrumentID = @InstrumentID and EMAssessmentCategoryID = @EMAssessmentCategoryID
			     
				  	
	--			 --then insert into table: tblEMAssessmentResultSection to get EMAssessmentResultSectionID
	--			 --first we get the EMAssessmentAnswerID
	--			 if (@EMAssessmentAnswerID = -1)
	--			 begin
	--				  SELECT @EMAssessmentAnswerID = [EMAssessmentAnswerID]
	--				  FROM [tblEMAssessmentAnswer]
	--				  WHERE [EMAssessmentQuestionID] = @EMAssessmentQuestionID and EMAssessmentAnswer = @EMAssessmentAnswer
					 
					  
					 
	--				  declare @EMAssessmentResultSectionIDTemp int
	--				  SELECT @EMAssessmentResultSectionIDTemp = ISNULL(A.EMAssessmentResultSectionID, 0) 
	--				  FROM tblEMAssessmentResultAnswer A 
	--				  INNER JOIN tblEMAssessmentResultSection B  ON A.EMAssessmentResultSectionID = B.EMAssessmentResultSectionID
	--				  INNER JOIN tblEMAssessmentResultCategory C ON B.EMAssessmentResultCategoryID = C.EMAssessmentResultCategoryID 
	--				  WHERE C.InstrumentID = @InstrumentID and C.EMAssessmentResultCategoryID = @EMAssessmentCategoryIDTemp and A.EMAssessmentAnswerID = @EMAssessmentAnswerID	
					  
					  
	--				  if @EMAssessmentResultSectionIDTemp is null OR @EMAssessmentResultSectionIDTemp = 0
	--				  begin
						  
	--					 insert into tblEMAssessmentResultSection
	--					 (
	--					 EMAssessmentResultCategoryID,
	--					 EMAssessmentSectionID,
	--					 DateCreated,
	--					 CreatedBySystemUserID
	--					 )
	--					 values
	--					 (
	--					 @EMAssessmentCategoryIDTemp,
	--					 @EMAssessmentSectionID,
	--					 getdate(),
	--					 @SystemUserId
	--					 )
	--					 select @EMAssessmentResultSectionIDTemp = @@IDENTITY
						 		     	
	--				  end
					  
	--				  --finally we do insert action
	--					insert into tblEMAssessmentResultAnswer
	--					(
	--						EMAssessmentResultSectionID,
	--						EMAssessmentAnswerID,
	--						EnteredValue,
	--						ProvidedReasonID,
	--						DateCreated,
	--						CreatedBySystemUserID		    
	--					) 
	--					values
	--					(
	--					  @EMAssessmentResultSectionIDTemp,
	--					  @EMAssessmentAnswerID,
	--					  case @EnteredValue when -1 then 0 else @EnteredValue end,
	--					  null,
	--					  getdate(),
	--					  @SystemUserId
	--					)		 
	--			 end
	--		   END	   
	--	end	   
	   
	--    SELECT @Cnt = @Cnt+1
 --End
 --delete @tblInsertRow					 