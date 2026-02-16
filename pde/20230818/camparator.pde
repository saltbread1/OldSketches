class BinaryBezierComparator implements Comparator<BinaryBezier>
{
    @Override
	public int compare(BinaryBezier arg1, BinaryBezier arg2)
    {
        float l1 = arg1.getRootLength();
        float l2 = arg2.getRootLength();
        // descending order
		if (l1 < l2) { return 1; }
		else if (l1 == l2) { return 0; }
		else { return -1; }
	}
}