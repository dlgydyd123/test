package ex03_method;

public class CalcMain {

	public static void main(String[] args) {
		Calc calc = new Calc();
		calc.sum(5, 11);
		
		int[] nums = {100,200};
		//필요에 따라 결과값을 변수에 저장하여 활용할 수 있다.
		int n = calc.sum(nums);
		System.out.println("숫자들의 합은 : " + n + "입니다.");
	}

}
