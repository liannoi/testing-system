namespace TestingSystem.Common.BL.BusinessObjects.NonEntities
{
    public class PassingTestResultBusinessObject
    {
        public StudentTestBusinessObject PassingDetails { get; set; }
        public int CountQuestions { get; set; }
        public int CountCorrentAnswered { get; set; }
        public int MaxGrade { get; set; }
        public double? PCA => PassingDetails.PCA;
        public int Grade => CountCorrentAnswered * MaxGrade / CountQuestions;
    }
}