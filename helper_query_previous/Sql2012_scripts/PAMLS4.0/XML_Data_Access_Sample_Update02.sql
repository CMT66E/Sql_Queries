declare @temp varchar(5000)
set @temp = '<DataRiskEMAssessment xmlns="http://tempuri.org/DataRiskEMAssessment.xsd">
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>1</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>6</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>2</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>6</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>1</EMAssessmentSectionID>
    <EMAssessmentSection>Successful prosecutions</EMAssessmentSection>
    <EMAssessmentQuestionID>1</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>3</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>6</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>4</EMAssessmentAnswerID>
    <EMAssessmentAnswer>1 year ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>5</EMAssessmentAnswerID>
    <EMAssessmentAnswer>2 years ago?</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>1</EMAssessmentCategoryID>
    <EMAssessmentSectionID>2</EMAssessmentSectionID>
    <EMAssessmentSection>Enforceable undertakings</EMAssessmentSection>
    <EMAssessmentQuestionID>2</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>6</EMAssessmentAnswerID>
    <EMAssessmentAnswer>3 years ago?</EMAssessmentAnswer>
    <EnteredValue>1</EnteredValue>
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
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>9</EMAssessmentSectionID>
    <EMAssessmentSection>Pollution reduction programs (PRPs)</EMAssessmentSection>
    <EMAssessmentQuestionID>10</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>28</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
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
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>12</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>32</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>12</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>33</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>34</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Incident related?</EMAssessmentAnswer>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>35</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Site surveys?</EMAssessmentAnswer>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>2</EMAssessmentCategoryID>
    <EMAssessmentSectionID>10</EMAssessmentSectionID>
    <EMAssessmentSection>Site inspections</EMAssessmentSection>
    <EMAssessmentQuestionID>13</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>36</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Other?</EMAssessmentAnswer>
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
    <EMAssessmentQuestionID>17</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>43</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>18</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>44</EMAssessmentAnswerID>
    <EMAssessmentAnswer>No</EMAssessmentAnswer>
    <EnteredValue>0</EnteredValue>
  </viewEMAssessmentResult>
  <viewEMAssessmentResult>
    <InstrumentID>4000005</InstrumentID>
    <EMAssessmentCategoryID>4</EMAssessmentCategoryID>
    <EMAssessmentSectionID>12</EMAssessmentSectionID>
    <EMAssessmentSection>Environmental systems and practices</EMAssessmentSection>
    <EMAssessmentQuestionID>19</EMAssessmentQuestionID>
    <EMAssessmentAnswerID>47</EMAssessmentAnswerID>
    <EMAssessmentAnswer>Yes</EMAssessmentAnswer>
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
</DataRiskEMAssessment>'

declare @posStart int
set @posStart = CHARINDEX('xmlns', @temp)

declare @posEnd int
set @posEnd = CHARINDEX('.xsd', @temp)

declare @tempStart varchar(MAX)
select @tempStart = RTRIM(SUBSTRING(@temp,1, CHARINDEX('xmlns', @temp) - 1))

declare @tempEnd varchar(MAX)
select @tempEnd = RTRIM(SUBSTRING(@temp, @posEnd + 5, 1)) + RTRIM(SUBSTRING(@temp, @posEnd + 6, LEN(@temp)-@posEnd + 6))

select @tempStart + @tempEnd
