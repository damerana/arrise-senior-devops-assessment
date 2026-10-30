# Account B – roleC

roleC trusts only the Account A roleB ARN. Its inline policy grants S3 actions on the named bucket ARN and its object ARN pattern. It does not grant access to other buckets. Cross-account assumption requires both sides: roleC's trust policy trusts roleB, and roleB's identity policy allows `sts:AssumeRole` on roleC.
